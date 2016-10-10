//
//  OneFieldTableViewCell.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/17/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

class OneFieldTableViewCell: UITableViewCell, TableCellProtocol {
    typealias T = OneFieldCellViewModel
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    func configure(cellViewModel: T) {
        titleLabel.text = cellViewModel.title
        if !cellViewModel.icon.isEmpty {
            iconImageView.image = UIImage(named: cellViewModel.icon)
        } else {
            iconImageView.image = nil
        }
    }
}
