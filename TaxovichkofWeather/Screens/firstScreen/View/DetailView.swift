//
//  DetailView.swift
//  TaxovichkofWeather
//
//  Created by Дмитрий Константинов on 23.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit
import SDWebImage

protocol DetailViewDelegate: AnyObject {
    func numberOfRowsInSection() -> Int
    func getModelAtIndex(index: Int) -> DetailCellModel?
    func selectedSegment(title: String?)
    func refreshTable()
}

protocol DetailViewUpdater {
    func setupSegmentedLine(titles: [String])
    func setStatusData(imageURL: URL?, mainText: String, descriptionText: String)
    func reloadTable()
    func endRefreshing()
}

class DetailView: UIView {

    private let statusView = CurrentWeatherView()
    private let segmentedLine = UISegmentedControl()
    private let tableView = UITableView(frame: CGRect.zero, style: .plain)
    private let spinner = UIActivityIndicatorView(style: .large)

    weak var delegate: DetailViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
        setupViews()
    }

    convenience init(delegate: DetailViewDelegate) {
        self.init()
        self.delegate = delegate
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }

    private func setupViews() {
        statusView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(statusView)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = #colorLiteral(red: 0.2936717272, green: 0.7476478219, blue: 0.2609704435, alpha: 0.6951519692)
        spinner.startAnimating()
        addSubview(spinner)

        segmentedLine.translatesAutoresizingMaskIntoConstraints = false
        segmentedLine.addTarget(self, action: #selector(selectedValue), for: .valueChanged)
        addSubview(segmentedLine)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.tintColor = #colorLiteral(red: 0.2936717272, green: 0.7476478219, blue: 0.2609704435, alpha: 0.6951519692)
        tableView.refreshControl?.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        tableView.register(UINib(nibName: "DetailTableViewCell", bundle: nil),
                           forCellReuseIdentifier: DetailTableViewCell.reuseIdentifier)
        tableView.rowHeight = 80
        addSubview(tableView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            statusView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            statusView.widthAnchor.constraint(equalToConstant: 200),
            statusView.heightAnchor.constraint(equalToConstant: 150),
            statusView.centerXAnchor.constraint(equalTo: self.centerXAnchor),

            spinner.centerYAnchor.constraint(equalTo: statusView.centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor),

            segmentedLine.topAnchor.constraint(equalTo: statusView.bottomAnchor, constant: 25),
            segmentedLine.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            segmentedLine.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            segmentedLine.heightAnchor.constraint(equalToConstant: 50),

            tableView.topAnchor.constraint(equalTo: segmentedLine.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    @objc private func selectedValue() {
        guard let title = segmentedLine.titleForSegment(at: segmentedLine.selectedSegmentIndex) else { return }
        delegate?.selectedSegment(title: title)
    }

    @objc private func refreshTable() {
        delegate?.refreshTable()
    }
}

// MARK: UITableViewDelegate & UITableViewDataSource
extension DetailView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate?.numberOfRowsInSection() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? DetailTableViewCell,
            let model = delegate?.getModelAtIndex(index: indexPath.row) else {
                return UITableViewCell()
        }

        cell.renderCell(imageURL: model.imageURL, mainText: model.mainText, secondaryText: model.secondaryText)
        return cell
    }
}

// MARK: DetailViewUpdater
extension DetailView: DetailViewUpdater {

    func setupSegmentedLine(titles: [String]) {
        for index in 0..<titles.count {
            segmentedLine.insertSegment(withTitle: titles[index], at: index, animated: true)
        }
        if segmentedLine.numberOfSegments > 0 {
            segmentedLine.selectedSegmentIndex = 0
        }
    }

    func setStatusData(imageURL: URL?, mainText: String, descriptionText: String) {
        DispatchQueue.main.async {
            self.statusView.imageView.sd_setImage(with: imageURL)
            self.statusView.statusLabel.text = mainText
            self.statusView.descriptionLabel.text = descriptionText
            self.spinner.stopAnimating()
        }
    }

    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func endRefreshing() {
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
}
