//
//  DetailModelController.swift
//  TaxovichkofWeather
//
//  Created by Дмитрий Константинов on 23.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

protocol DetailModelControllerProtocol {
    func getFavoriteCities(completion: @escaping (Result<[FavoriteCity], Error>) -> Void)
}

class DetailModelController: DetailModelControllerProtocol {

    private let networkService: NetworkServiceProtocol
    private var database: FavoriteCitySource

    required init(networkService: NetworkServiceProtocol,
                  database: FavoriteCitySource) {
        self.networkService = networkService
        self.database = database
    }

    func getFavoriteCities(completion: @escaping (Result<[FavoriteCity], Error>) -> Void) {

        createFavoriteCities { error in
            if let error = error {
                completion(.failure(error))
                return
            }
        }

        do {
            var favorites = try database.getAllFavoritesCity()
            if favorites.first?.currentWeather == nil {
                let workItem = DispatchWorkItem {
                    self.getWeatherOfFavoriteCitiesFromApi { error in
                        if let error = error {
                            DispatchQueue.main.async {
                                completion(.failure(error))
                                return
                            }
                        }
                    }
                }
                workItem.notify(queue: DispatchQueue.main) {
                    do {
                        favorites = try self.database.getAllFavoritesCity()
                        completion(.success(favorites.map { $0.toModel() }))
                    } catch {
                        completion(.failure(error))
                        return
                    }
                }
                DispatchQueue.global().async(execute: workItem)
            } else {
                completion(.success(favorites.map { $0.toModel() }))
                return
            }
        } catch {
            completion(.failure(error))
        }
    }

    private func createFavoriteCities(completion: @escaping (Error?) -> Void) {

        do {
            if try database.getAllFavoritesCity().count > 0 {
                completion(nil)
                return
            }
        } catch {
            completion(error)
        }

        let saintP = FavoriteCity(cityId: 498817, name: "Санкт-Петербург",
                                  longitude: 30.26, latitude: 59.89,
                                  currentWeather: nil, dailyWeather: [])
        let moscow = FavoriteCity(cityId: 524901, name: "Москва",
                                  longitude: 37.62, latitude: 55.75,
                                  currentWeather: nil, dailyWeather: [])
        do {
            try database.addFavorite(city: saintP)
            try database.addFavorite(city: moscow)
            completion(nil)
        } catch {
            completion(RealmError.createFavoriteError)
        }
    }

    private func getWeatherOfFavoriteCitiesFromApi(completion: @escaping (Error?) -> Void) {
        do {
            let favorites = try database.getAllFavoritesCity()
            favorites.forEach { cityRealm in
                let city = cityRealm.toModel()
                networkService.getCityWeather(latitude: String(city.latitude),
                                              longitude: String(city.longitude)) { result in
                                                switch result {
                                                case .success(let data):
                                                    let current = data.currentToModel(cityId: city.cityId)
                                                    let daily = data.dailyToModel(cityId: city.cityId)
                                                    do {
                                                        try self.database.updateWeather(cityId: city.cityId,
                                                                                            current: current,
                                                                                            daily: daily)
                                                    } catch {
                                                        completion(error)
                                                    }
                                                case .failure(let error):
                                                    completion(error)
                                                }
                }
            }
        } catch {
            completion(error)
        }
    }
}
