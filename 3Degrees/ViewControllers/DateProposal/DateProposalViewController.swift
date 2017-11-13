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
    @IBOutlet weak var mmNameLabel: UIButton!
    @IBOutlet weak var whoseMmLabel: UIButton!
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

        self.viewModel?.suggestedBy.observe {[unowned self] matchmakerOpt in
            if let matchmaker = matchmakerOpt {
                self.mmNameLabel.setTitle(R.string.localizable.suggestedByMatchmakerPrefix() + " " + matchmaker.fullName.trimmed, forState: UIControlState.Normal)
            }
        }
        self.viewModel?.iAmConnected.observe {[unowned self] iAmConnected in
            if iAmConnected {
                self.mmNameLabel.userInteractionEnabled = true
                self.whoseMmLabel.userInteractionEnabled = false
                self.whoseMmLabel.setTitle("", forState: UIControlState.Normal)
                self.whoseMmLabel.removeFromSuperview()
                self.mmNameLabel.bnd_tap.observe{[unowned self] () in
                    if let matchmaker = self.viewModel?.suggestedBy.value {
                        self.viewModel!.routeToMessages(matchmaker.username!)
                    }
                }
            } else {
                self.mmNameLabel.userInteractionEnabled = false
                self.whoseMmLabel.userInteractionEnabled = true
                self.whoseMmLabel.hidden = false
                if let suggestedBy = self.viewModel?.suggestedBy.value {
                    self.whoseMmLabel.setTitle(R.string.localizable.relatedMatchmakerPrefix() + " " + suggestedBy.userMatchmakers.first!.fullName.trimmed, forState: UIControlState.Normal)
                    self.whoseMmLabel.bnd_tap.observe{[unowned self] () in
                        if let matchmaker = self.viewModel!.suggestedBy.value!.userMatchmakers.first {
                            self.viewModel!.routeToMessages(matchmaker.username!)
                        }
                    }
                }
            }
            self.tableView.reloadData()
        }

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
