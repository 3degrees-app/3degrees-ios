//
//  ActivityItemTableViewCell.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/10/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import Bond

class ActivityItemTableViewCell: UITableViewCell, TableCellProtocol {
    typealias T = ActivityItemViewModel
    @IBOutlet weak var backgroundContainerView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var bodyTextLabel: UILabel!

    @IBOutlet weak var actionsStackView: UIStackView!

    private var cellViewModel: T? = nil

    func configure(cellViewModel: T) {
        self.cellViewModel = cellViewModel
        self.cellViewModel?.showConfirmationCallback = self.showConfirmationMessage
        clearActionStackView()
        setStyles()
        configureButtonsStyle()
        let fullName = cellViewModel.activityItem.originUser?.fullName ?? ""
        avatarImageView.setAvatarImage(cellViewModel.acivityUserAvatar, fullName: fullName)
        userNameLabel.bnd_text.next(fullName)
        bodyTextLabel.bnd_text.next(cellViewModel.activityItem.message)
        layoutSubviews()
    }

    func showConfirmationMessage(message: String) {
        UIView.animateWithDuration(0.5) {[unowned self] in
            self.clearActionStackView()
            let textButton = UIButton()
            textButton.configureTextButton(message)
            self.actionsStackView.addArrangedSubview(textButton)
        }
    }

    private func setStyles() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        avatarImageView.layer.masksToBounds = true
        separatorView.backgroundColor = Constants.ActivityAndHistory.BackgroundBorderColor
        backgroundContainerView.backgroundColor = Constants.ActivityAndHistory.CellItemBackground
        backgroundContainerView.layer.borderWidth = 1
        backgroundContainerView.layer.borderColor = Constants.ActivityAndHistory.BackgroundBorderColor.CGColor
        userNameLabel.textColor = Constants.ActivityAndHistory.NameAndBodyLabelColor
        bodyTextLabel.textColor = Constants.ActivityAndHistory.NameAndBodyLabelColor

        bringSubviewToFront(actionsStackView)
        sendSubviewToBack(backgroundContainerView)
    }

    private func configureButtonsStyle() {
        let responses = cellViewModel?.activityItem.responses
        guard let actions = responses where !actions.isEmpty else {
            guard let message = cellViewModel?.activityItem.responseMessage else {
                clearActionStackView()
                return
            }
            showConfirmationMessage(message)
            return
        }
        for action in actions {
            guard let activityType = action.activityResponseType else {
                continue
            }
            switch activityType {
            case .ConnectionRequestAccept:
                configureAcceptButton(action.text, confirmation: action.responseMessage)
            case .ConnectionRequestDecline:
                configureDeclineButton(action.text, confirmation: action.responseMessage)
            case .MessageReceivedView, .DateAcceptedChat, .MatchAcceptedChat:
                configureViewButton(action.text) {[unowned self] in
                    self.cellViewModel?.showMessagesScreen()
                }
            case .DateSuggestedView:
                configureViewButton(action.text) {[weak self] in
                    self?.cellViewModel?.showSuggestedTimes()
                }
            case .MatchSuggestedView, .MatchSuggestedSecondDegreeView:
                configureViewButton(action.text) {[unowned self] in
                    self.cellViewModel?.showMainTab()
                    self.cellViewModel?.postOriginUserToShow()
                }
                break
            case .MatchAcceptedByMeSuggest:
                configureViewButton(action.text) {[weak self] in
                    self?.cellViewModel?.suggestTimes()
                }
            }
        }
    }

    private func configureNotSupportedButton(title: String?) {
        guard let title = title else { return }
        let button = UIButton()
        actionsStackView.addArrangedSubview(button)
        actionsStackView.bringSubviewToFront(button)
        button.configureTextButton(title)
    }

    private func configureViewButton(title: String?,
                                     action: () -> ()) {
        guard let title = title else { return }
        let button = UIButton()
        button.configureViewButton(title)
        actionsStackView.addArrangedSubview(button)
        actionsStackView.bringSubviewToFront(button)
        button.bnd_tap.observe {
            action()
        }
    }

    private func configureAcceptButton(title: String?, confirmation: String?) {
        guard let title = title else { return }
        let button = UIButton()
        button.configureAcceptButton(title)
        actionsStackView.addArrangedSubview(button)
        actionsStackView.bringSubviewToFront(button)
        button.bnd_tap.observe {[unowned self] in
            self.cellViewModel?.acceptConnectionInvite (confirmation)
        }
    }

    private func configureDeclineButton(title: String?, confirmation: String?) {
        guard let title = title else { return }
        let button = UIButton()
        button.configureDeclineButton(title)
        actionsStackView.addArrangedSubview(button)
        actionsStackView.bringSubviewToFront(button)
        button.bnd_tap.observe {[unowned self] in
            self.cellViewModel?.declineConnectionInvite(confirmation)
        }
    }

    private func clearActionStackView() {
        actionsStackView.arrangedSubviews.forEach {[unowned self] view in
            self.actionsStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}
