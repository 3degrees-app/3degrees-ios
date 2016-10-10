//
//  ProposedTimeCollectionViewCell.swift
//  3Degrees
//
//  Created by Gigster Developer on 9/4/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

class ProposedTimeCollectionViewCell: UICollectionViewCell, TableCellProtocol {
    typealias T = ProposedTimeCellViewModel

    @IBOutlet weak var label: DetailScheduleItemView!

    func configure(cellViewModel: T) {
        label.configure(cellViewModel.value,
                        selected: cellViewModel.selected,
                        disabled: cellViewModel.disabled)
    }
}
