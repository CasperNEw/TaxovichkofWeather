//
//  FavoriteCity.swift
//  TaxovichkofWeather
//
//  Created by Дмитрий Константинов on 23.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

struct FavoriteCity {

    let cityId: Int
    let name: String
    let longitude: Double
    let latitude: Double

    var currentWeather: CityWeather?
    var dailyWeather: [CityWeather]
}
