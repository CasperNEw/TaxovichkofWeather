//
//  DetailView.swift
//  TaxovichkofWeather
//
//  Created by Дмитрий Константинов on 23.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

//protocol DetailViewDelegate {
//
//}

class DetailView: UIView {

    let statusImageView = UIImageView()
    let statusLabel = UILabel()
    let descriptionLabel = UILabel()
    let segmentedLine = UISegmentedControl()
    let tableView = UITableView(frame: CGRect.zero, style: .plain)

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .orange
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }

    func setupViews() {
        statusImageView.translatesAutoresizingMaskIntoConstraints = false
        statusImageView.contentMode = .scaleAspectFit
        statusImageView.backgroundColor = .cyan
        addSubview(statusImageView)

        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.text = "-44℃"
        statusLabel.textAlignment = .center
        statusLabel.font = .systemFont(ofSize: 35, weight: .medium)
        statusLabel.adjustsFontSizeToFitWidth = true
        statusLabel.sizeToFit()
        statusLabel.backgroundColor = .white
        addSubview(statusLabel)

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = "Прохладно"
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = .systemFont(ofSize: 35, weight: .medium)
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.sizeToFit()
        descriptionLabel.backgroundColor = .lightGray
        addSubview(descriptionLabel)

        segmentedLine.translatesAutoresizingMaskIntoConstraints = false
        segmentedLine.backgroundColor = .systemPink
        addSubview(segmentedLine)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .yellow
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "DetailTableViewCell", bundle: nil),
                           forCellReuseIdentifier: DetailTableViewCell.reuseIdentifier)
        tableView.rowHeight = 80
        addSubview(tableView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            statusImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            statusImageView.widthAnchor.constraint(equalToConstant: 100),
            statusImageView.heightAnchor.constraint(equalToConstant: 100),
            statusImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -50),

            statusLabel.widthAnchor.constraint(equalToConstant: 100),
            statusLabel.heightAnchor.constraint(equalToConstant: 100),
            statusLabel.topAnchor.constraint(equalTo: statusImageView.topAnchor),
            statusLabel.leadingAnchor.constraint(equalTo: statusImageView.trailingAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: statusImageView.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: statusImageView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: statusLabel.trailingAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 50),

            segmentedLine.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 25),
            segmentedLine.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            segmentedLine.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            segmentedLine.heightAnchor.constraint(equalToConstant: 50),

            tableView.topAnchor.constraint(equalTo: segmentedLine.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension DetailView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? DetailTableViewCell else {
                                                        return UITableViewCell()
        }
        let image = UIImage(systemName: "moon")
        cell.renderCell(image: image, mainText: "-44℃", secondaryText: "СР, 24 Июня")
        return cell
    }
}

// MARK: SwiftUI
import SwiftUI

struct DetailViewProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let detailVC = DetailViewController()
        // swiftlint:disable line_length
        func makeUIViewController(context: UIViewControllerRepresentableContext<DetailViewProvider.ContainerView>) -> DetailViewController {
            return detailVC
        }
        func updateUIViewController(_ uiViewController: DetailViewController, context: UIViewControllerRepresentableContext<DetailViewProvider.ContainerView>) {
        }
        // swiftlint:enable line_lenght
    }
}
