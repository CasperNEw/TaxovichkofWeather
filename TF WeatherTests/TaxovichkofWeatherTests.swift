//
//  TF_WeatherTests.swift
//  TF WeatherTests
//
//  Created by Дмитрий Константинов on 26.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import XCTest
@testable import TF_Weather

class MockDetailModelController: DetailModelControllerProtocol {

    let favorites = [FavoriteCity(cityId: 001, name: "Baz",
                                  longitude: 0.0, latitude: 0.0,
                                  currentWeather: CityWeather(cityId: 001, currentDate: 000,
                                                              forecastDate: 000, icon: "Bar",
                                                              temp: 0.0, description: "Foo"),
                                  dailyWeather: [])]

    var names: [String] {
            var names: [String] = []
            favorites.forEach { city in
                names.append(city.name)
            }
            return names
    }

    func updateAndGetFavoriteCities(completion: @escaping (Result<[FavoriteCity], Error>) -> Void) {
        let error = NSError(domain: "Error", code: 007)
        completion(.failure(error))
    }

    func getFavoriteCities(completion: @escaping (Result<[FavoriteCity], Error>) -> Void) {
        completion(.success(favorites))
    }

    func createURLStringForIcon(icon: String) -> String {
        return icon + "Foo"
    }
}

class MockDetailView: DetailViewUpdater {

    //swiftlint:disable large_tuple
    var titles: [String] = []
    var status: (URL?, String, String) = (nil, "Baz", "Bar")
    var update: (Bool, Bool) = (false, false)
    //swiftlint:enable large_tuple

    func setupSegmentedLine(titles: [String]) {
        self.titles = titles
    }

    func setStatusData(imageURL: URL?, mainText: String, descriptionText: String) {
        status = (imageURL, mainText, descriptionText)
    }

    func reloadTable() {
        update.0 = true
    }

    func endRefreshing() {
        update.1 = true
    }
}

class TaxovichkofWeatherTests: XCTestCase {

    var detailModelController: MockDetailModelController!
    var detailView: MockDetailView!
    var view: UIView!
    var viewControllerFactory: ViewControllerFactory!
    var detailController: DetailViewController!

    override func setUp() {
        detailModelController = MockDetailModelController()
        detailView = MockDetailView()
        view = UIView()
        viewControllerFactory = ViewControllerFactory()
        detailController = DetailViewController(view: view,
                                                viewUpdater: detailView,
                                                modelController: detailModelController,
                                                viewControllerFactory: viewControllerFactory)
    }

    override func tearDown() {
        detailModelController = nil
        detailView = nil
        view = nil
        viewControllerFactory = nil
        detailController = nil
    }

    func testDetailViewSegmentedLineTitles() {
        detailController.getData()
        XCTAssertEqual(detailView.titles, detailModelController.names)
    }

    func testDetailViewStatusViewUpdated() {
        detailController.selectedSegment(title: "Baz")
        XCTAssertEqual(detailView.status.0, URL(string: "BarFoo"))
        XCTAssertNotEqual(detailView.status.1, "")
        XCTAssertNotEqual(detailView.status.2, "")
    }

    func testDetailViewRefreshAndReload() {
        XCTAssertTrue(detailView.update.0)
        XCTAssertFalse(detailView.update.1)

        detailController.refreshTable()
        XCTAssertTrue(detailView.update.1)
    }
}
