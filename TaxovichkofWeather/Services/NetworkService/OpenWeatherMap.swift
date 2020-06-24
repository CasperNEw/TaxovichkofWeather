//
//  OpenWeatherMap.swift
//  TaxovichkofWeather
//
//  Created by Дмитрий Константинов on 23.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

class OpenWeatherMap {

    static var profile = OpenWeatherMap()
    private let key = "dc5f36e0bd0a8dddf2eb6a6b44cb0427"

    private init() { }

    func getApiKey() -> String {
        return key
    }
}
