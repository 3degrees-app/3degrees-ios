//
//  HeaderTableViewCell.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/17/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import Bond

class HeaderTableViewCell: UITableViewCell, TableCellProtocol {
    typealias T = HeaderCellViewModel
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userInfoLabel: UILabel!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var matchButton: UIButton!


    func configure(cellViewModel: T) {
        avatarImageView.setAvatarImage(cellViewModel.avatar,
                                       fullName: cellViewModel.name)
        contentView.sendSubviewToBack(avatarImageView)
        nameLabel.text = cellViewModel.name
        nameLabel.textColor = Constants.Profile.NameLabelColor
        nameLabel.dropShadow()
        userInfoLabel.text = cellViewModel.info
        chatButton.bnd_tap.observe(cellViewModel.chatButtonPressed)
        matchButton.bnd_hidden.next(AppController.shared.currentUserMode.value == .Single)
        matchButton.bnd_tap.observe(cellViewModel.matchButtonPressed)
    }

}
