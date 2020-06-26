//
//  CurrentWeatherView.swift
//  TaxovichkofWeather
//
//  Created by Дмитрий Константинов on 25.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class CurrentWeatherView: UIView {

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30, weight: .medium)
        label.adjustsFontSizeToFitWidth = true
        label.sizeToFit()
        return label
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.adjustsFontSizeToFitWidth = true
        label.sizeToFit()
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(imageView)
        addSubview(statusLabel)
        addSubview(descriptionLabel)
        setupConstraints()
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),

            statusLabel.topAnchor.constraint(equalTo: self.topAnchor),
            statusLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor),
            statusLabel.widthAnchor.constraint(equalToConstant: 100),
            statusLabel.heightAnchor.constraint(equalToConstant: 100),

            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 50),

            self.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor),
            self.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
