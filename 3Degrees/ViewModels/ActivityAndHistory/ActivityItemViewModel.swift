//
//  ActivityItemViewModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/10/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import Router
import ThreeDegreesClient
import SwiftMoment

class ActivityItemViewModel: ViewModelProtocol, Routable {
    var api: ActivityApiProtocol = ActivityApiController()
    var dateProposalApi: DateProposalApiProtocol = DateProposalApiController()
    var appNavigator: AppNavigator? = nil
    let activityItem: Activity
    let router = Router()
    var showConfirmationCallback: ((message: String) -> ())? = nil

    var activityUsername: String? {
        var usernameFromEntity: String? = nil
        if let usernameFromAttrs = activityItem.attributes?.username {
            usernameFromEntity = usernameFromAttrs
        } else if let usernameFromOriginUser = activityItem.originUser?.username {
            usernameFromEntity = usernameFromOriginUser
        }
        return usernameFromEntity
    }

    var acivityUserAvatar: String? {
        var icon = activityItem.icon
        if let userAvatarUrl = activityItem.originUser?.avatarUrl {
            icon = userAvatarUrl
        }
        return icon
    }

    init(activityItem: Activity, appNavigator: AppNavigator?) {
        self.activityItem = activityItem
        self.appNavigator = appNavigator
    }

    func acceptConnectionInvite(confirmation: String?) {
        guard let username = activityUsername where !username.isEmpty else { return }
        api.acceptConnection(username) {
            guard let m = confirmation else { return }
            self.showConfirmationMesssage(m)
        }
    }


    func declineConnectionInvite(confirmation: String?) {
        guard let username = activityUsername else { return }
        api.declineConnection(username) {
            guard let m = confirmation else { return }
            self.showConfirmationMesssage(m)
        }
    }

    @objc func showMessagesScreen() {
        guard let username = activityUsername else { return }
        self.routeToMessages(username)
    }

    func showMainTab() {
        appNavigator?.switchTab(tabNumber: 1)
    }

    func postOriginUserToShow() {
        guard let user = activityItem.originUser else { return }
        NSNotificationCenter.showSuggestedMatchWithUser(user)
    }

    func showSuggestedTimes() {
        guard let username = activityUsername else { return }
        api.getUser(username) {[weak self] (user) in
            self?.dateProposalApi.getSuggestedTimes(username) { (dates) in
                guard let vc = R.storyboard.dateProposalScene.scheduleResultsViewController()
                    else { return }
                vc.mode = .Accept(dates: dates.map { moment($0) })
                vc.user = user
                self?.appNavigator?.showVcAction(vc: vc)
            }
        }
    }

    func suggestTimes() {
        guard let username = activityUsername else { return }
        api.getUser(username) {[weak self] (user) in
            guard let vc = R.storyboard.dateProposalScene.scheduleResultsViewController()
                else { return }
            vc.mode = .Choose
            vc.user = user
            self?.appNavigator?.showVcAction(vc: vc)
        }
    }

    func showConfirmationMesssage(confirmation: String) {
        activityItem.responses?.removeAll()
        var message = confirmation
        extractItemMessage: if message.isEmpty {
            guard let msg = self.activityItem.responseMessage else { break extractItemMessage }
            message = msg
        } else {
            activityItem.responseMessage = confirmation
        }
        self.showConfirmationCallback?(message: message)
    }
}
