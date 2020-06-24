//
//  DetailTableViewCell.swift
//  TaxovichkofWeather
//
//  Created by Дмитрий Константинов on 24.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!

    static let reuseIdentifier = "DetailTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.mainImageView.image = nil
        self.mainLabel.text = ""
        self.secondaryLabel.text = ""
    }

    func renderCell(image: UIImage?, mainText: String, secondaryText: String) {
        self.mainImageView?.image = image
        self.mainLabel?.text = mainText
        self.secondaryLabel?.text = secondaryText
    }
}
