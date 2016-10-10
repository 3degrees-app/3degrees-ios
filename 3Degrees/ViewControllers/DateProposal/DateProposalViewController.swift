//
//  DateProposalViewController.swift
//  3Degrees
//
//  Created by Gigster Developer on 9/2/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import DynamicBlurView

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
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var blurView: DynamicBlurView!
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

        blurView.blurRatio = 10
        blurView.blurRadius = 10
        blurView.dynamicMode = .None

        acceptButton.titleLabel?.dropShadow()
        declineButton.titleLabel?.dropShadow()
    }

    func configureBindings() {
        tableView.delegate = viewModel
        guard let user = viewModel?.user else {
            return
        }
        avatarImageView.setAvatarImage(user.avatarUrl, fullName: user.fullName) {[unowned self] in
            self.blurView.refresh()
        }
        blurView.refresh()
        nameTextField.bnd_text.next(user.fullName)
        userInfoTextField.bnd_text.next(user.info)

        mmNameLabel.bnd_text.next(user.matchmakerInfo)


        whoseMmLabel.bnd_text.next(user.firstName ?? "" + "'s Matchmaker")

        titleLabel.bnd_text.next(user.title)
        placeOfWorkLabel.bnd_text.next(user.placeOfWork)
        degreeLabel.bnd_text.next(user.degree)
        schoolLabel.bnd_text.next(user.school)
        bioLabel.bnd_text.next(user.biography)

        acceptButton.bnd_tap.observe {[unowned self] () in
            self.viewModel?.accept()
        }

        declineButton.bnd_tap.observe {[unowned self] () in
            self.viewModel?.decline()
        }
        tableView.reloadData()
    }
}
