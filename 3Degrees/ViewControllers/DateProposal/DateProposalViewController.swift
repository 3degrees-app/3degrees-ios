//
//  DateProposalViewController.swift
//  3Degrees
//
//  Created by Gigster Developer on 9/2/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

class DateProposalViewController: UITableViewController, ViewProtocol {

    var viewModel: DateProposalViewModel? = nil

    @IBOutlet weak var nameTextField: UILabel!
    @IBOutlet weak var userInfoTextField: UILabel!
    @IBOutlet weak var mmNameLabel: UILabel!
    @IBOutlet weak var whoseMmLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var placeOfWorkLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var avatarMaskView: UIView!


    override func viewDidLoad() {
        super.viewDidLoad()
        applyDefaultStyle()
        configureBindings()
    }

    func applyDefaultStyle() {
        tableView.backgroundColor = Constants.ViewOnBackground.Color
        tableView.tableFooterView = UIView()
        tableView.preservesSuperviewLayoutMargins = false

        acceptButton.titleLabel?.dropShadow()
        declineButton.titleLabel?.dropShadow()
    }

    func configureBindings() {
        tableView.delegate = viewModel
        guard let user = viewModel?.user else {
            return
        }
        avatarImageView.setAvatarImage(user.avatarUrl, fullName: user.fullName)
        nameTextField.bnd_text.next(user.fullName)
        userInfoTextField.bnd_text.next(user.info)

        mmNameLabel.bnd_text.next(user.matchmakerInfo)


        whoseMmLabel.bnd_text.next(user.firstName ?? "" + "'s Matchmaker")

        titleLabel.bnd_text.next(user.title)
        placeOfWorkLabel.bnd_text.next(user.placeOfWork)
        degreeLabel.bnd_text.next(user.degree)
        schoolLabel.bnd_text.next(user.school)
        bioLabel.bnd_text.next(user.biography)
        heightLabel.bnd_text.next(user.heightString)

        acceptButton.bnd_tap.observe {[unowned self] () in
            self.viewModel?.accept()
        }
        buttonize(acceptButton, color: UIColor(r: 0, g: 255, b: 0, a: 0.25))
        buttonize(declineButton, color: UIColor(r: 255, g: 0, b: 0, a: 0.25))
        nameTextField.textColor = Constants.Profile.NameLabelColor
        nameTextField.font = nameTextField.font.fontWithSize(30)
        nameTextField.dropShadow()
        userInfoTextField.textColor = Constants.Profile.NameLabelColor
        userInfoTextField.dropShadow()

        declineButton.bnd_tap.observe {[unowned self] () in
            self.viewModel?.decline()
        }
        tableView.reloadData()
    }

    func buttonize(button: UIButton, color: UIColor) {
        // TODO: There is no set width; if the button text is different widths, the buttons won't look standardized.
        button.backgroundColor = color
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.contentEdgeInsets.bottom = 5
        button.contentEdgeInsets.left = 10
        button.contentEdgeInsets.right = 10
        button.contentEdgeInsets.top = 5
    }
}
