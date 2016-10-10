//
//  TwoFieldsTableViewCell.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/17/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

class TwoFieldsTableViewCell: UITableViewCell, TableCellProtocol {
    typealias T = TwoFieldsCellViewModel
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!

    func configure(cellViewModel: T) {
        titleLabel.text = cellViewModel.title
        subtitleLabel.text = cellViewModel.subtitle
        if !cellViewModel.icon.isEmpty {
            icon.image = UIImage(named: cellViewModel.icon)
        } else {
            icon.image = nil
        }
    }
}
