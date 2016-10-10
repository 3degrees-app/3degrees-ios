//
//  ProposedDatesDescriptionTableViewCell.swift
//  3Degrees
//
//  Created by Gigster Developer on 9/4/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

class ProposedDatesDescriptionTableViewCell: UITableViewCell, TableCellProtocol {
    typealias T = ProposedDatesDescriptionCellViewModel

    @IBOutlet weak var descriptionLabel: UILabel!

    func configure(cellViewModel: T) {
        descriptionLabel.text = cellViewModel.description
    }
}
