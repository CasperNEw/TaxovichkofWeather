//
//  CityWeatherRealm.swift
//  TaxovichkofWeather
//
//  Created by Дмитрий Константинов on 23.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import RealmSwift

class CityWeatherRealm: Object {

    @objc dynamic var cityId = 0
    @objc dynamic var currentDate = 0
    @objc dynamic var forecastDate = 0
    @objc dynamic var icon = ""
    @objc dynamic var temp = 0.0
    @objc dynamic var writeUp = ""

    func toModel() -> CityWeather {
        return CityWeather(cityId: cityId, currentDate: currentDate,
                           forecastDate: forecastDate, icon: icon,
                           temp: temp, description: writeUp)
    }

    func fromModel(optWeather: CityWeather?) -> CityWeatherRealm? {
        guard let weather = optWeather else { return nil }
        return fromModel(weather: weather)
    }

    func fromModel(weather: CityWeather) -> CityWeatherRealm {
        self.cityId = weather.cityId
        self.currentDate = weather.currentDate
        self.forecastDate = weather.forecastDate
        self.icon = weather.icon
        self.temp = weather.temp
        self.writeUp = weather.description
        return self
    }
}
