//
//  CoordsWeatherRealm.swift
//  TaxovichkofWeather
//
//  Created by Дмитрий Константинов on 25.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import RealmSwift

class CoordsWeatherRealm: Object {

    @objc dynamic var cityId = 0
    @objc dynamic var name = ""
    @objc dynamic var longitude = 0.0
    @objc dynamic var latitude = 0.0
    @objc dynamic var forecastDate = 0
    @objc dynamic var icon = ""
    @objc dynamic var temp = 0.0
    @objc dynamic var writeUp = ""

    override static func primaryKey() -> String? {
        return "cityId"
    }

    func toModel() -> WeatherByCoorinates {
        return WeatherByCoorinates(cityId: self.cityId, name: self.name, longitude: self.longitude,
                                   latitude: self.latitude, forecastDate: self.forecastDate,
                                   icon: self.icon, temp: self.temp, description: self.writeUp)
    }

    func fromModel(weather: WeatherByCoorinates) {
        self.cityId = weather.cityId
        self.name = weather.name
        self.longitude = weather.longitude
        self.latitude = weather.latitude
        self.forecastDate = weather.forecastDate
        self.icon = weather.icon
        self.temp = weather.temp
        self.writeUp = weather.description
    }
}
