//
//  CurrentWeatherViewController.swift
//  TaxovichkofWeather
//
//  Created by Дмитрий Константинов on 25.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

protocol CurrentWeatherViewControllerProtocol: UIViewController {
    func setData(imageURL: URL?, mainText: String, descriptionText: String, name: String)
    func dismiss()
}

class CurrentWeatherViewController: UIViewController {

    private let currentView = CurrentWeatherView()
    private let nameLabel = UILabel()
    private let spinner = UIActivityIndicatorView(style: .large)

    private var didSetupConstraints = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    override func updateViewConstraints() {

        if !didSetupConstraints {
            setupConstraints()
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        eraseView()
    }

    private func setup() {
        currentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(currentView)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textAlignment = .center
        nameLabel.font = .systemFont(ofSize: 20, weight: .medium)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.sizeToFit()
        view.addSubview(nameLabel)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = #colorLiteral(red: 0.2941176471, green: 0.7476478219, blue: 0.2609704435, alpha: 0.7043011558)
        spinner.startAnimating()
        view.addSubview(spinner)
        view.backgroundColor = #colorLiteral(red: 0.6329556704, green: 0.813773632, blue: 0.9472417235, alpha: 0.5)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            currentView.topAnchor.constraint(equalTo: view.topAnchor),
            currentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            currentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            nameLabel.topAnchor.constraint(equalTo: currentView.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 50),

            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func eraseView() {
        currentView.imageView.image = nil
        currentView.statusLabel.text = ""
        currentView.descriptionLabel.text = ""
        nameLabel.text = ""
        spinner.startAnimating()
    }
}

// MARK: CurrentWeatherViewControllerProtocol
extension CurrentWeatherViewController: CurrentWeatherViewControllerProtocol {

    func setData(imageURL: URL?, mainText: String, descriptionText: String, name: String) {
        DispatchQueue.main.async {
            self.currentView.imageView.sd_setImage(with: imageURL)
            self.currentView.statusLabel.text = mainText
            self.currentView.descriptionLabel.text = descriptionText
            self.nameLabel.text = name
            self.spinner.stopAnimating()
        }
    }

    func dismiss() {
        self.dismiss(animated: true)
    }
}
