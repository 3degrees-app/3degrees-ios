//
//  SelectValueTableViewCell.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/7/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

class SelectValueTableViewCell: UITableViewCell, TableCellProtocol {
    typealias T = SelectValueCellViewModel
    @IBOutlet weak var valueLabel: UILabel!

    func configure(cellViewModel: T) {
        self.preservesSuperviewLayoutMargins = false
        valueLabel.applySelectValueLabelStyles()
        valueLabel.bnd_text.next(cellViewModel.valueName)
    }
}
