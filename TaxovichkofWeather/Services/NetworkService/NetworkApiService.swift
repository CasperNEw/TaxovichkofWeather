//
//  NetworkApiService.swift
//  TaxovichkofWeather
//
//  Created by Дмитрий Константинов on 23.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

protocol NetworkApiServiceProtocol {

    func findCityWeatherBy(name: String, completion: @escaping (Result<CurrentCityWeatherFromServer, Error>) -> Void)
    func getCityWeather(latitude: String, longitude: String,
                        completion: @escaping (Result<CityWeatherFromServer, Error>) -> Void)
}

class NetworkApiService: NetworkApiServiceProtocol {

    let key = OpenWeatherMap.profile.getApiKey()

    func findCityWeatherBy(name: String,
                           completion: @escaping (Result<CurrentCityWeatherFromServer, Error>) -> Void) {

        let queryItem  = [URLQueryItem(name: "q", value: name),
                          URLQueryItem(name: "units", value: "metric"),
                          URLQueryItem(name: "lang", value: "ru"),
                          URLQueryItem(name: "appid", value: key)]

        requestServer(urlQueryItem: queryItem) { completion($0) }
    }

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

    private func requestServer<T: Decodable>(urlQueryItem: [URLQueryItem],
                                             completion: @escaping (Result<T, Error>) -> Void) {

        var component = URLComponents()
        component.scheme = "https"
        component.host = "api.openweathermap.org"
        component.path = "/data/2.5/onecall"
        component.queryItems = urlQueryItem

        guard let url = component.url else { return }

        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }

            guard let data = data else { return }

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
        }
        task.resume()
    }
}
