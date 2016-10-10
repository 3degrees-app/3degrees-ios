//
//  SelectActionTableViewCell.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/7/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

class SelectActionTableViewCell: UITableViewCell, TableCellProtocol {
    typealias T = SelectActionViewModelProtocol


    @IBOutlet weak var actionNameLabel: UILabel!

    @IBOutlet weak var valueLabel: UILabel!

    func configure(cellViewModel: T) {
        self.preservesSuperviewLayoutMargins = false
        actionNameLabel.text = cellViewModel.actionName
        cellViewModel.observableValue.bindTo(valueLabel.bnd_text)
        valueLabel.applyActionValueLabelStyles()
        actionNameLabel.applyActionLabelStyles()
    }
}
