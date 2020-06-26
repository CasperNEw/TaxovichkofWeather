//
//  CityWeatherFromServer.swift
//  TaxovichkofWeather
//
//  Created by Дмитрий Константинов on 23.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

// MARK: - Weather
struct CityWeatherFromServer: Codable {
    let lat, lon: Double
    let current: Current
    let daily: [Daily]

    enum CodingKeys: String, CodingKey {
        case lat, lon
        case current, daily
    }
}

extension CityWeatherFromServer {

    func currentToModel(cityId: Int) -> CityWeather? {
        guard let weather = current.weather.first else { return nil }
        return CityWeather(cityId: cityId,
                           currentDate: current.timeData,
                           forecastDate: current.timeData,
                           icon: weather.icon,
                           temp: current.temp,
                           description: weather.description)
    }

    func dailyToModel(cityId: Int) -> [CityWeather] {
        var dailyWeather: [CityWeather] = []

        daily.forEach { daily in
            guard let weather = daily.weather.first else { return }
            let cityWeather = CityWeather(cityId: cityId,
                                          currentDate: current.timeData,
                                          forecastDate: daily.timeData,
                                          icon: weather.icon,
                                          temp: daily.temp.day,
                                          description: weather.description)
            dailyWeather.append(cityWeather)
        }
        return dailyWeather
    }
}

// MARK: - Current
struct Current: Codable {
    let timeData: Int
    let temp: Double
    let weather: [Weather]

    enum CodingKeys: String, CodingKey {
        case timeData = "dt"
        case temp
        case weather
    }
}

// MARK: - Daily
struct Daily: Codable {
    let timeData: Int
    let temp: Temp
    let weather: [Weather]

    enum CodingKeys: String, CodingKey {
        case timeData = "dt"
        case temp
        case weather
    }
}

// MARK: - Temp
struct Temp: Codable {
    let day: Double
}
