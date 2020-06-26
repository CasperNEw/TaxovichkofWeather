//
//  CoordsWeatherRepository.swift
//  TaxovichkofWeather
//
//  Created by Дмитрий Константинов on 25.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import RealmSwift

protocol CoordsWeatherSource {
    func addWeather(weather: WeatherByCoorinates) throws
    func getWeather(longitude: Double, latitude: Double) throws -> WeatherByCoorinates?
    func checkForExpiredData() throws
}

class CoordsWeatherRepository: CoordsWeatherSource {

    lazy private var validCurrentTime: Int = {
        return Int(Date().timeIntervalSince1970) - 3600
    }()

    func addWeather(weather: WeatherByCoorinates) throws {
        do {
            let realm = try Realm()
            try realm.write {
                let weatherRealm = CoordsWeatherRealm()
                weatherRealm.fromModel(weather: weather)
                realm.add(weatherRealm, update: .modified)
            }
        }
    }

    func getWeather(longitude: Double, latitude: Double) throws -> WeatherByCoorinates? {
        do {
            let realm = try Realm()
            return realm.objects(CoordsWeatherRealm.self)
                .filter("longitude == %@ AND latitude == %@", longitude, latitude)
                .first?.toModel()
        }
    }

    func checkForExpiredData() throws {
        do {
            let realm = try Realm()
            let expired = realm.objects(CoordsWeatherRealm.self)
                .filter("forecastDate >= %@", validCurrentTime)
            try realm.write {
                realm.delete(expired)
            }
        } catch {
            throw error
        }
    }
}
