//
//  MapViewController.swift
//  TaxovichkofWeather
//
//  Created by Дмитрий Константинов on 25.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {

    private var coordinates: Coordinates?
    private let popOver: CurrentWeatherViewControllerProtocol
    private let modelController: MapModelControllerProtocol

    // MARK: Init
    init(coordinates: Coordinates?,
         modelController: MapModelControllerProtocol,
         popOver: CurrentWeatherViewControllerProtocol) {
        self.coordinates = coordinates
        self.modelController = modelController
        self.popOver = popOver
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        createMap(coordinates)
        checkForExpiredData()
    }

    private func createMap(_ coordinates: Coordinates?) {

        let camera = GMSCameraPosition.camera(withLatitude: coordinates?.latitude ?? -33.86,
                                              longitude: coordinates?.longitude ?? 151.20,
                                              zoom: 10.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        self.view.addSubview(mapView)
    }

    private func checkForExpiredData() {
        modelController.checkForExpiredData { [weak self] error in
            if error != nil {
                self?.showAlert(with: "Error", and: RealmError.readWriteError.localizedDescription)
            }
        }
    }
}

// MARK: GMSMapViewDelegate
extension MapViewController: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        setupAndPresentPopOverVC()
        modelController
            .getWeatherByCoordinates(latitude: String(coordinate.latitude),
                                     longitude: String(coordinate.longitude)) { [weak self] result in
                                        switch result {
                                        case .success(let weather):
                                            guard let weather = weather else { return }
                                            guard let imageURL = self?.modelController
                                                .createURLStringForIcon(icon: weather.icon) else { return }
                                            self?.popOver.setData(imageURL: URL(string: imageURL),
                                                                  mainText: String((weather.temp*10)
                                                                    .rounded(.towardZero)/10) + "℃",
                                                                  descriptionText: weather.description,
                                                                  name: weather.name)
                                        case .failure(let error):
                                            self?.popOver.dismiss()
                                            print(error)
                                        }
        }
    }
}

// MARK: setupAndPresentPopOverVC & UIPopoverPresentationControllerDelegate
extension MapViewController: UIPopoverPresentationControllerDelegate {
    private func setupAndPresentPopOverVC() {

        popOver.modalPresentationStyle = .popover
        guard let popOverPC = popOver.popoverPresentationController else { return }
        popOverPC.delegate = self
        popOverPC.sourceView = view
        popOverPC.sourceRect = CGRect(x: view.bounds.midX, y: 90, width: 0, height: 0)
        popOver.preferredContentSize = CGSize(width: 240, height: 190)
        self.present(popOver, animated: true)
    }

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
