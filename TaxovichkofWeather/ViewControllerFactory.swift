//
//  ViewControllerFactory.swift
//  TaxovichkofWeather
//
//  Created by Дмитрий Константинов on 23.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class ViewControllerFactory {

    func makeDetailViewController() -> UIViewController {
        let view = DetailView()
        let networkService = NetworkApiService()
        let database = FavoriteCityRealmRepository()
        let modelController = DetailModelController(networkService: networkService,
                                                    database: database)
        let viewController = DetailViewController(view: view,
                                                  viewUpdater: view,
                                                  modelController: modelController,
                                                  viewControllerFactory: self)
        view.delegate = viewController
        return viewController
    }

    func makeMapViewController(with coordinates: Coordinates?) -> UIViewController {
        let networkService = NetworkApiService()
        let database = CoordsWeatherRepository()
        let modelController = MapModelController(networkService: networkService,
                                                 database: database)
        let popOverViewController = CurrentWeatherViewController()
        let viewController = MapViewController(coordinates: coordinates,
                                               modelController: modelController,
                                               popOver: popOverViewController)
        return viewController
    }
}
