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
    let timezone: String
    let timezoneOffset: Int
    let current: Current
    let daily: [Daily]

    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset
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
    let timeData, sunrise, sunset: Int
    let temp, feelsLike: Double // temp
    let pressure, humidity: Int
    let dewPoint, uvi: Double
    let clouds, visibility, windSpeed, windDeg: Int
    let weather: [Weather] // !

    enum CodingKeys: String, CodingKey {
        case timeData = "dt"
        case sunrise, sunset, temp
        case feelsLike
        case pressure, humidity
        case dewPoint
        case uvi, clouds, visibility
        case windSpeed
        case windDeg
        case weather
    }
}

// MARK: - Daily
struct Daily: Codable {
    let timeData, sunrise, sunset: Int // dataTime
    let temp: Temp // беру daу temp!
    let feelsLike: FeelsLike
    let pressure, humidity: Int
    let dewPoint, windSpeed: Double
    let windDeg: Int
    let weather: [Weather] // !
    let clouds: Int
    let uvi: Double
    let rain: Double?

    enum CodingKeys: String, CodingKey {
        case timeData = "dt"
        case sunrise, sunset, temp
        case feelsLike
        case pressure, humidity
        case dewPoint
        case windSpeed
        case windDeg
        case weather, clouds, uvi, rain
    }
}

// MARK: - FeelsLike
struct FeelsLike: Codable {
    let day, night, eve, morn: Double
}

// MARK: - Temp
struct Temp: Codable {
    let day, min, max, night: Double
    let eve, morn: Double
}
