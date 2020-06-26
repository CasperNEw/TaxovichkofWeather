//
//  NetworkApiService.swift
//  TaxovichkofWeather
//
//  Created by Дмитрий Константинов on 23.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

protocol NetworkApiServiceProtocol {

    func getCityWeather(latitude: String, longitude: String,
                        completion: @escaping (Result<CityWeatherFromServer, Error>) -> Void)
    func getWeatherByCoordinates(latitude: String, longitude: String,
                                 completion: @escaping (Result<WeatherByCoordinatesFromServer, Error>) -> Void)
    func createURLStringForIcon(icon: String) -> String
}

class NetworkApiService: NetworkApiServiceProtocol {

    let key = OpenWeatherMap.profile.getApiKey()

    func getCityWeather(latitude: String, longitude: String,
                        completion: @escaping (Result<CityWeatherFromServer, Error>) -> Void) {

        let queryItem = [URLQueryItem(name: "lat", value: latitude),
                         URLQueryItem(name: "lon", value: longitude),
                         URLQueryItem(name: "exclude", value: "hourly,minutely"),
                         URLQueryItem(name: "units", value: "metric"),
                         URLQueryItem(name: "lang", value: "ru"),
                         URLQueryItem(name: "appid", value: key)]

        requestServer(urlQueryItem: queryItem) { completion($0) }
    }

    func getWeatherByCoordinates(latitude: String, longitude: String,
                                 completion: @escaping (Result<WeatherByCoordinatesFromServer, Error>) -> Void) {

        let path = "/data/2.5/weather"
        let queryItem = [URLQueryItem(name: "lat", value: latitude),
                         URLQueryItem(name: "lon", value: longitude),
                         URLQueryItem(name: "units", value: "metric"),
                         URLQueryItem(name: "lang", value: "ru"),
                         URLQueryItem(name: "appid", value: key)]

        requestServer(urlQueryItem: queryItem, path: path) { completion($0) }
    }

    func createURLStringForIcon(icon: String) -> String {
        return "https://openweathermap.org/img/wn/" + icon + "@2x.png"
    }

    private func requestServer<T: Decodable>(urlQueryItem: [URLQueryItem],
                                             path: String? = nil,
                                             completion: @escaping (Result<T, Error>) -> Void) {

        var component = URLComponents()
        component.scheme = "https"
        component.host = "api.openweathermap.org"
        component.path = path ?? "/data/2.5/onecall"
        component.queryItems = urlQueryItem

        guard let url = component.url else { return }

        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in

            if let data = data {
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(result))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
                return
            }
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
