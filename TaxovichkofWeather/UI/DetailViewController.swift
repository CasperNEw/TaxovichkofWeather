//
//  DetailViewController.swift
//  TaxovichkofWeather
//
//  Created by Дмитрий Константинов on 23.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var modelController: DetailModelControllerProtocol?

    // MARK: Init
    init(view: UIView) {
        super.init(nibName: nil, bundle: nil)
        self.view = view
//        setup()
    }

    // MARK: hack for canvas SwiftUI
    convenience init() {
        let mainView = DetailView()
        self.init(view: mainView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        let networkService = NetworkApiService()
        let database = FavoriteCityRealmRepository()
        modelController = DetailModelController(networkService: networkService, database: database)
        modelController?.getFavoriteCities { result in
            switch result {
            case .success(let favorites):
                print(favorites)
            case .failure(let error):
                print(error)
            }
        }
    }
}
