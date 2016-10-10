//
//  ProposedPersonCollectionCell.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/20/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

class ProposedPersonCollectionCell: UICollectionViewCell, TableCellProtocol {
    typealias T = ProposedPersonCellViewModel
    static let identifier = R.reuseIdentifier.proposedPersonCollectionCell.identifier

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!


    func configure(cellViewModel: T) {
        avatarImageView.setAvatarImage(cellViewModel.person.avatarUrl,
                                       fullName: cellViewModel.person.fullName)
        nameLabel.text = cellViewModel.person.fullName
        nameLabel.textColor = Constants.PairUp.NameColor
        nameLabel.dropShadow(0.5)
        infoLabel.text = cellViewModel.person.info
        infoLabel.textColor = Constants.PairUp.InfoColor
    }
}
