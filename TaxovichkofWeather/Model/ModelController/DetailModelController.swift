//
//  DetailModelController.swift
//  TaxovichkofWeather
//
//  Created by Дмитрий Константинов on 23.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

protocol DetailModelControllerProtocol {
    func createFavoriteCities(completion: @escaping (Error?) -> Void)
}

class DetailModelController {

    private let networkService: NetworkServiceProtocol
    private var database: FavoriteCitySource
    private var favoriteCities: [FavoriteCity]?

    required init(networkService: NetworkServiceProtocol,
                  database: FavoriteCitySource) {
        self.networkService = networkService
        self.database = database
    }

    func createFavoriteCities(completion: @escaping (Error?) -> Void) {
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
            completion(error)
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

    private func getFavoriteCitiesFromDatabase() {
        do {
            let favorites = try database.getAllFavoritesCity()
            favoriteCities = favorites.map { $0.toModel() }
        } catch {
            print(error)
        }
    }
}
