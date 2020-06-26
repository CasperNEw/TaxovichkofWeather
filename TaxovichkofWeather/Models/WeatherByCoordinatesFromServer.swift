//
//  WeatherByCoordinatesFromServer.swift
//  TaxovichkofWeather
//
//  Created by Дмитрий Константинов on 25.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

struct WeatherByCoordinatesFromServer: Codable {
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let timeData: Int
    let cityId: Int
    let name: String

    enum CodingKeys: String, CodingKey {
           case coord, weather, main
           case timeData = "dt"
           case cityId = "id"
           case name
       }
}

extension WeatherByCoordinatesFromServer {

    func toModel() -> WeatherByCoorinates? {
        guard let weather = self.weather.first else { return nil }
        let model = WeatherByCoorinates(cityId: self.cityId, name: self.name, longitude: self.coord.lon,
                                          latitude: self.coord.lat, forecastDate: self.timeData,
                                          icon: weather.icon, temp: self.main.temp,
                                          description: weather.description)
        return model
    }
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Weather
struct Weather: Codable {
    let description, icon: String
}

// MARK: - Main
struct Main: Codable {
    let temp: Double
}
