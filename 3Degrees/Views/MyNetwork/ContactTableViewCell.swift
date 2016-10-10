//
//  ContactTableViewCell.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/13/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import Kingfisher

class ContactTableViewCell: UITableViewCell, TableCellProtocol {
    typealias T = ContactViewModel

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var contactView: UIView!

    func configure(cellViewModel: T) {
        preservesSuperviewLayoutMargins = false
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        avatarImageView.layer.masksToBounds = true

        nameLabel.bnd_text.next(cellViewModel.name)
        infoLabel.bnd_text.next(cellViewModel.info)

        infoLabel.textColor = Constants.MyNetwork.InfoLabelColor
        nameLabel.textColor = Constants.MyNetwork.NameLabelColor

        avatarImageView.setAvatarImage(cellViewModel.avatarUrl,
                                       fullName: cellViewModel.name)
    }
}
