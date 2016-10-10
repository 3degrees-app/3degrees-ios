//
//  MatchmakerCollectionViewCell.swift
//  3Degrees
//
//  Created by Gigster Developer on 7/26/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

class MatchmakerCollectionViewCell: UICollectionViewCell, TableCellProtocol {
    typealias T = MatchmakerCellViewModel
    @IBOutlet weak var matchmakerNameLabel: UILabel!

    func configure(cellViewModel: T) {
        matchmakerNameLabel.text = cellViewModel.matchmaker.fullName
    }
}
