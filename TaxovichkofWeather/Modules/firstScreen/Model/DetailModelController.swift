//
//  DetailModelController.swift
//  TaxovichkofWeather
//
//  Created by Дмитрий Константинов on 23.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

protocol DetailModelControllerProtocol {
    func updateAndGetFavoriteCities(completion: @escaping (Result<[FavoriteCity], Error>) -> Void)
    func getFavoriteCities(completion: @escaping (Result<[FavoriteCity], Error>) -> Void)
    func createURLStringForIcon(icon: String) -> String
}

class DetailModelController: DetailModelControllerProtocol {

    private let networkService: NetworkApiServiceProtocol
    private var database: FavoriteCitySource

    required init(networkService: NetworkApiServiceProtocol,
                  database: FavoriteCitySource) {
        self.networkService = networkService
        self.database = database
    }

    func updateAndGetFavoriteCities(completion: @escaping (Result<[FavoriteCity], Error>) -> Void) {
        getWeatherOfFavoriteCitiesFromApi { completion($0) }
    }

    func getFavoriteCities(completion: @escaping (Result<[FavoriteCity], Error>) -> Void) {

        createFavoriteCities { error in
            if let error = error {
                completion(.failure(error))
                return
            }
        }

        do {
            let favorites = try database.getAllFavoritesCity()
            if favorites.first?.currentWeather == nil {
                self.getWeatherOfFavoriteCitiesFromApi { completion($0) }
                return
            } else {
                completion(.success(favorites.map { $0.toModel()}))
                return
            }
        } catch {
            completion(.failure(error))
        }
    }

    func createURLStringForIcon(icon: String) -> String {
        return networkService.createURLStringForIcon(icon: icon)
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

    private func getWeatherOfFavoriteCitiesFromApi(completion: @escaping (Result<[FavoriteCity], Error>) -> Void) {
        do {
            let favorites = try database.getAllFavoritesCity()
            var operationCounter = 0
            favorites.forEach { cityRealm in
                let city = cityRealm.toModel()
                self.networkService
                    .getCityWeather(latitude: String(city.latitude),
                                    longitude: String(city.longitude)) { result in
                                        switch result {
                                        case .success(let data):
                                            let current = data.currentToModel(cityId: city.cityId)
                                            let daily = data.dailyToModel(cityId: city.cityId)
                                            do {
                                                try self.database.updateWeather(cityId: city.cityId,
                                                                                current: current,
                                                                                daily: daily)
                                                operationCounter += 1
                                                if operationCounter == favorites.count {
                                                    let newFavorites = try self.database.getAllFavoritesCity()
                                                    completion(.success(newFavorites.map { $0.toModel() }))
                                                }
                                            } catch {
                                                completion(.failure(RealmError.readWriteError))
                                            }
                                        case .failure(let error):
                                            completion(.failure(error))
                                        }
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
}
