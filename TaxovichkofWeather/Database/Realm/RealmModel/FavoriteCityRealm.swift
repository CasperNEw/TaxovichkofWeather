//
//  FavoriteCityRealm.swift
//  TaxovichkofWeather
//
//  Created by Дмитрий Константинов on 23.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import RealmSwift

class FavoriteCityRealm: Object {

    @objc dynamic var cityId = 0
    @objc dynamic var name = ""
    @objc dynamic var longitude = 0.0
    @objc dynamic var latitude = 0.0
    @objc dynamic var currentWeather: CityWeatherRealm?
    @objc dynamic var dailyWeather: [CityWeatherRealm] = []

    override static func primaryKey() -> String? {
        return "cityId"
    }

    func toModel() -> FavoriteCity {
        var daily: [CityWeather] = []
        dailyWeather.forEach { weather in
            daily.append(weather.toModel())
        }
        return FavoriteCity(cityId: cityId, name: name,
                            longitude: longitude, latitude: latitude,
                            currentWeather: currentWeather?.toModel(),
                            dailyWeather: daily)
    }
}
