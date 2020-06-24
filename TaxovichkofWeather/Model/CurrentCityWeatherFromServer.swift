//
//  CurrentCityWeatherFromServer.swift
//  TaxovichkofWeather
//
//  Created by Дмитрий Константинов on 23.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

// MARK: - CityWeather
struct CurrentCityWeatherFromServer: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let timeData: Int
    let sys: Sys
    let timezone, cityId: Int
    let name: String
    let cod: Int

    enum CodingKeys: String, CodingKey {
        case coord, weather, base, main, visibility, wind, clouds
        case timeData = "dt"
        case sys, timezone
        case cityId = "id"
        case name, cod
    }
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin: Double
    let tempMax, pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike
        case tempMin
        case tempMax
        case pressure, humidity
    }
}

// MARK: - Sys
struct Sys: Codable {
    let type, sysId: Int
    let country: String
    let sunrise, sunset: Int

    enum CodingKeys: String, CodingKey {
        case type
        case sysId = "id"
        case country, sunrise, sunset
    }
}

// MARK: - Weather
struct Weather: Codable {
    let weatherId: Int
    let main, description, icon: String

    enum CodingKeys: String, CodingKey {
        case weatherId = "id"
        case main, description, icon
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed, deg: Int
}
