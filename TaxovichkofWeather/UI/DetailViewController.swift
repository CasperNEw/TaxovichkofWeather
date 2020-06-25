//
//  DetailViewController.swift
//  TaxovichkofWeather
//
//  Created by Дмитрий Константинов on 23.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    private var modelController: DetailModelControllerProtocol
    private var model: [FavoriteCity]?
    private var selectedSegment: String?
    private var viewUpdater: DetailViewUpdater
    private let formatter = DateFormatter()

    // MARK: Init
    init(view: UIView, viewUpdater: DetailViewUpdater,
         modelController: DetailModelControllerProtocol) {
        self.viewUpdater = viewUpdater
        self.modelController = modelController
        super.init(nibName: nil, bundle: nil)
        self.view = view
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        modelController.getFavoriteCities { [weak self] result in
            switch result {
            case .success(let favorites):
                self?.model = favorites
                self?.viewUpdater.setupSegmentedLine(titles: favorites.map { $0.name })
                self?.selectedSegment(title: favorites.map({ $0.name }).first)
            case .failure(let error):
                self?.showAlert(with: "Error", and: error.localizedDescription)
            }
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "map"),
                                                            style: .plain, target: self,
                                                            action: #selector(mapButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = .lightGray
    }

    @objc private func mapButtonTapped() {
        print(#function)
    }
}

// MARK: DetailViewDelegate
extension DetailViewController: DetailViewDelegate {

    func numberOfRowsInSection() -> Int {
        return model?.filter { $0.name == selectedSegment }.first?.dailyWeather.count ?? 0
    }

    func getModelAtIndex(index: Int) -> DetailCellModel? {

        guard let weather = model?
            .filter({ $0.name == selectedSegment })
            .first?.dailyWeather[index] else {
                return nil
        }

        let imageURL = modelController.createURLStringForIcon(icon: weather.icon)
        return DetailCellModel(imageURL: URL(string: imageURL),
                               mainText: String((weather.temp*10).rounded(.towardZero)/10) + "℃",
                               secondaryText: prepareDate(unixTime: weather.forecastDate))
    }

    func selectedSegment(title: String?) {
        selectedSegment = title
        guard let weather = model?
            .filter({ $0.name == title })
            .first?.currentWeather else {
                return
        }

        let imageURL = modelController.createURLStringForIcon(icon: weather.icon)
        viewUpdater.setStatusData(imageURL: URL(string: imageURL),
                                   mainText: String((weather.temp*10).rounded(.towardZero)/10) + "℃",
                                   descriptionText: weather.description.uppercased())
        viewUpdater.reloadTable()
    }

    func refreshTable() {
        modelController.updateAndGetFavoriteCities { [weak self] result in
            switch result {
            case .success(let favorites):
                self?.model = favorites
                self?.viewUpdater.endRefreshing()
                self?.viewUpdater.reloadTable()
            case .failure(let error):
                self?.viewUpdater.endRefreshing()
                self?.showAlert(with: "Error", and: error.localizedDescription)
            }
        }
    }
}

// MARK: prepareDate
extension DetailViewController {

    private func prepareDate(unixTime: Int) -> String {
        formatter.dateFormat = "EEEEEE, d MMMM"
        formatter.locale = Locale(identifier: "ru")
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
        return formatter.string(from: date)
    }
}
