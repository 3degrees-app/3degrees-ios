//
//  SwitchActionTableViewCell.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/7/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

class SwitchActionTableViewCell: UITableViewCell, TableCellProtocol {
    typealias T = SwitchActionViewModel

    @IBOutlet weak var actionNameLabel: UILabel!

    @IBOutlet weak var actionSwitch: UISwitch!

    var viewModel: T? = nil

    func configure(cellViewModel: T) {
        viewModel = cellViewModel
        self.preservesSuperviewLayoutMargins = false
        actionNameLabel.text = cellViewModel.actionName
        actionNameLabel.applyActionLabelStyles()
        actionSwitch.applyActionSwitchStyles()
        actionSwitch.on = cellViewModel.switchValue
        actionSwitch.bnd_on.observeNew {[weak self] (isOn) in
            self?.viewModel?.switchValueChanged(isOn)
        }
    }
}
