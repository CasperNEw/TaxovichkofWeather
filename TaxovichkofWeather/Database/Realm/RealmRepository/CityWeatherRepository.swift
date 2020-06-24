//
//  CityWeatherRepository.swift
//  TaxovichkofWeather
//
//  Created by Дмитрий Константинов on 23.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import RealmSwift

protocol CityWeatherSource {
    func getCurrentCityWeatherAt(cityId: Int) throws -> CityWeatherRealm?
    func getDailyCityWeatherAt(cityId: Int) throws -> Results<CityWeatherRealm>
    func addCityWeather(weather: [CityWeather]) throws
    func deleteExpiredData() throws
}

class CityWeatherRealmRepository: CityWeatherSource {

    lazy private var validCurrentTime: Int = {
        let time = getValidCurrentUnixTime()
        return time
    }()
    lazy private var validDailyTime: Int = {
        let time = getValidDailyUnixTime()
        return time
    }()

    func getCurrentCityWeatherAt(cityId: Int) throws -> CityWeatherRealm? {
        do {
            let realm = try Realm()

            return realm.objects(CityWeatherRealm.self)
                .filter("cityId == %@ AND currentDate == forecastDate AND forecastDate >= %@", cityId, validCurrentTime)
                .sorted(byKeyPath: "forecastDate", ascending: false)
                .first
        } catch {
            throw error
        }
    }

    func getDailyCityWeatherAt(cityId: Int) throws -> Results<CityWeatherRealm> {
        do {
            let realm = try Realm()
            return realm.objects(CityWeatherRealm.self)
                .filter("cityId == %@ AND currentDate != forecastDate AND forecastDate >= %@", cityId, validDailyTime)
                .sorted(byKeyPath: "forecastDate", ascending: false)
        } catch {
            throw error
        }
    }

    func addCityWeather(weather: [CityWeather]) throws {
        do {
            let realm = try Realm()
            try realm.write {
                var weatherToAdd = [CityWeatherRealm]()
                weather.forEach { element in
                    let weather = CityWeatherRealm()
                    weather.cityId = element.cityId
                    weather.currentDate = element.currentDate
                    weather.forecastDate = element.forecastDate
                    weather.icon = element.icon
                    weather.temp = element.temp
                    weather.writeUp = element.description
                    weatherToAdd.append(weather)
                }
                realm.add(weatherToAdd, update: .modified)
            }
        } catch {
            throw error
        }
    }

    func deleteExpiredData() throws {
        do {
            let realm = try Realm()

            let expiredCurrentWeather = realm.objects(CityWeatherRealm.self)
                .filter("currentDate == forecastDate AND forecastDate < %@", validCurrentTime)
            let expiredDailyWeather = realm.objects(CityWeatherRealm.self)
                .filter("currentDate != forecastDate AND forecastDate < %@", validDailyTime)

            try realm.write {
                realm.delete(expiredCurrentWeather)
                realm.delete(expiredDailyWeather)
            }
        } catch {
            throw error
        }
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
