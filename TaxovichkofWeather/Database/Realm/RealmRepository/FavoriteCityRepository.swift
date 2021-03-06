//
//  FavoriteCityRepository.swift
//  TaxovichkofWeather
//
//  Created by Дмитрий Константинов on 23.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import RealmSwift

protocol FavoriteCitySource {
    func getAllFavoritesCity() throws -> Results<FavoriteCityRealm>
    func addFavorite(city: FavoriteCity) throws
    func updateWeather(cityId: Int, current: CityWeather?, daily: [CityWeather]) throws
    func deleteFavorite(cityId: Int) throws
}

class FavoriteCityRealmRepository: FavoriteCitySource {

    lazy private var validCurrentTime: Int = {
        let time = getValidCurrentUnixTime()
        return time
    }()
    lazy private var validDailyTime: Int = {
        let time = getValidDailyUnixTime()
        return time
    }()

    func getAllFavoritesCity() throws -> Results<FavoriteCityRealm> {
        do {
            let realm = try Realm()
            let favorites = realm.objects(FavoriteCityRealm.self)
            let favoritesVerifiedData = try checkForExpiredData(cities: favorites)
            try realm.write {
                favoritesVerifiedData.forEach { $0.cache.removeAll() }
                realm.add(favoritesVerifiedData, update: .modified)
            }
            return favoritesVerifiedData
        } catch {
            throw error
        }
    }

    func addFavorite(city: FavoriteCity) throws {
        do {
            let realm = try Realm()
            try realm.write {
                let favoriteCity = FavoriteCityRealm()
                favoriteCity.cityId = city.cityId
                favoriteCity.name = city.name
                favoriteCity.longitude = city.longitude
                favoriteCity.latitude = city.latitude
                realm.add(favoriteCity, update: .modified)
            }
        } catch {
            throw error
        }
    }

    func updateWeather(cityId: Int, current: CityWeather?, daily: [CityWeather]) throws {
        do {
            let realm = try Realm()
            guard let favorite = realm.objects(FavoriteCityRealm.self).filter("cityId == %@", cityId).first else {
                throw RealmError.findFavoriteError
            }
            try realm.write {
                favorite.currentWeather = CityWeatherRealm().fromModel(optWeather: current)
                favorite.dailyWeather.removeAll()
                favorite.dailyWeather.append(objectsIn: daily.map { CityWeatherRealm().fromModel(weather: $0) })
                realm.add(favorite, update: .modified)
            }
        } catch {
            throw error
        }
    }

    func deleteFavorite(cityId: Int) throws {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(realm.objects(FavoriteCityRealm.self).filter("cityId == %@", cityId))
            }
        } catch {
            throw error
        }
    }
}

// MARK: work with expired data
extension FavoriteCityRealmRepository {

    func checkForExpiredData(cities: Results<FavoriteCityRealm>) throws -> Results<FavoriteCityRealm> {

        let checkedCities = cities
        try checkedCities.forEach { city in
            if let currentWeather = city.currentWeather {
                if currentWeather.forecastDate < validCurrentTime {
                    do {
                        let realm = try Realm()
                        try realm.write {
                            city.currentWeather = nil
                        }
                    } catch {
                        throw RealmError.expiredDataError
                    }
                } else {
                    return
                }
            }
            let daily = city.dailyWeather.filter("forecastDate >= %@", validDailyTime)
            do {
                let realm = try Realm()
                try realm.write {
                    city.cache.append(objectsIn: daily)
                    realm.add(city, update: .modified)
                    city.dailyWeather.removeAll()
                    city.dailyWeather.append(objectsIn: city.cache)
                    realm.add(city, update: .modified)
                }
            } catch {
                throw RealmError.expiredDataError
            }
        }
        return checkedCities
    }

    private func getValidCurrentUnixTime() -> Int {
        return Int(Date().timeIntervalSince1970) - 3600
    }

    private func getValidDailyUnixTime() -> Int {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.minute, .hour, .day, .month, .year, .timeZone], from: Date())
        components.minute = 00
        components.hour = 00
        components.timeZone = TimeZone(abbreviation: "GMT")
        let guardTime = Int(Date().timeIntervalSince1970)

        guard let lastDate = calendar.date(from: components) else { return guardTime }
        let unixTime = Int(lastDate.timeIntervalSince1970)
        return unixTime
    }
}
