//
//  SelectedDateTimeTableViewCell.swift
//  3Degrees
//
//  Created by Gigster Developer on 9/4/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

class SelectedDateTimeTableViewCell: UITableViewCell, TableCellProtocol {
    typealias T = SelectedDateTimeCellViewModel

    var viewModel: T? = nil

    @IBOutlet weak var dateTimeLabel: UILabel!

    func configure(cellViewModel: T) {
        viewModel = cellViewModel
        dateTimeLabel.text = viewModel?.cellValue
        dateTimeLabel.layer.borderColor = Constants.DateProposal.ProceedButtonColor.CGColor
        dateTimeLabel.layer.borderWidth = 1
        dateTimeLabel.layer.cornerRadius = 2
        dateTimeLabel.textColor = Constants.DateProposal.ProceedButtonColor
    }

    @IBAction func accept(sender: AnyObject) {
        viewModel?.accept()
    }
}
