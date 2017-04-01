//
//  ContactSearchTableViewCell.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/23/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

class ContactSearchTableViewCell: UITableViewCell, TableCellProtocol {
    typealias T = ContactSearchCellViewModel

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var connectionsInfoLabel: UILabel!
    @IBOutlet weak var inviteButton: UIButton!


    func configure(cellViewModel: T) {
        avatarImageView.applyDefaultAvatarStyle()
        avatarImageView.setAvatarImage(cellViewModel.avatarUrl,
                                       fullName: cellViewModel.contact.fullName)
        nameLabel.bnd_text.next(cellViewModel.contact.fullName)
        connectionsInfoLabel.bnd_text.next(cellViewModel.info)
        configureInviteButton(cellViewModel)
    }

    func configureInviteButton(viewModel: T) {
        if viewModel.mode == .Select {
            inviteButton.hidden = true
            return
        }
        inviteButton.setTitle(R.string.localizable.inviteTitle(), forState: .Normal)
        inviteButton.backgroundColor = Constants.MyNetwork.InviteButtonColor
        inviteButton.setTitleColor(Constants.MyNetwork.InviteButtonTextColor, forState: .Normal)
        inviteButton.bnd_tap.observeNew {[unowned self] in
            viewModel.invite(self.userWasInvited)
        }
    }

    func userWasInvited(completion: () -> ()) {
        inviteButton.backgroundColor = UIColor.clearColor()
        UIView.animateWithDuration(1, animations: {
            self.inviteButton.bnd_title.next(R.string.localizable.inviteSentTitle())
            self.inviteButton.setTitleColor(.blackColor(), forState: .Normal)
        }) {(r) in
            UIView.animateWithDuration(0.4, delay: 1, options: [], animations: {
                completion()
            }, completion: nil)
        }
    }
}
