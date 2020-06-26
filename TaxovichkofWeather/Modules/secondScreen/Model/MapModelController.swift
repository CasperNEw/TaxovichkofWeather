//
//  MapModelController.swift
//  TaxovichkofWeather
//
//  Created by Дмитрий Константинов on 25.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

protocol MapModelControllerProtocol {
    func getWeatherByCoordinates(latitude: String, longitude: String,
                                 completion: @escaping (Result<WeatherByCoorinates?, Error>) -> Void)
    func createURLStringForIcon(icon: String) -> String
}

class MapModelController: MapModelControllerProtocol {

    private let networkService: NetworkApiServiceProtocol
    private var database: CoordsWeatherSource

    required init(networkService: NetworkApiServiceProtocol,
                  database: CoordsWeatherSource) {
        self.networkService = networkService
        self.database = database
    }

    func getWeatherByCoordinates(latitude: String, longitude: String,
                                 completion: @escaping (Result<WeatherByCoorinates?, Error>) -> Void) {

        do {
            if let lon = Double(longitude), let lat = Double(latitude) {
                guard let result = try database.getWeather(longitude: lon, latitude: lat) else {

                    networkService.getWeatherByCoordinates(latitude: latitude, longitude: longitude) { result in
                        switch result {
                        case .success(let data):
                            guard let weather = data.toModel() else {
                                completion(.success(nil))
                                return
                            }
                            do {
                                try self.database.addWeather(weather: weather)
                            } catch {
                                completion(.failure(error))
                            }
                            completion(.success(weather))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                    return
                }
                completion(.success(result))
            }
        } catch {
            completion(.failure(error))
        }
    }

    func createURLStringForIcon(icon: String) -> String {
        return networkService.createURLStringForIcon(icon: icon)
    }
}
