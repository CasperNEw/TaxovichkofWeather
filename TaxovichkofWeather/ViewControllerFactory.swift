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
        let viewController = DetailViewController(view: view)
//        view.delegate = viewController
        return viewController
    }
}
