//
//  ActionTableViewCell.swift
//  3Degrees
//
//  Created by Gigster Developer on 4/28/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

class ActionTableViewCell: UITableViewCell, TableCellProtocol {
    typealias T = ActionCellViewModelProtocol
    @IBOutlet weak var actionNameLabel: UILabel!

    func configure(cellViewModel: ActionCellViewModelProtocol) {
        self.preservesSuperviewLayoutMargins = false
        actionNameLabel.text = cellViewModel.actionName
        actionNameLabel.applyActionLabelStyles()
    }
}
