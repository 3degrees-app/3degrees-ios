//
//  DateProposalViewModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/8/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import Router
import ThreeDegreesClient

protocol DateProposalRefreshDelegate {
    func actionWasTaken(user: UserInfo)
}

extension DateProposalViewModel: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let row = indexPath.row
        switch row {
        case 0:
            return UIScreen.mainScreen().bounds.height / 2
        case 2:
            guard user.placeOfWork.isEmpty && user.title.isEmpty else { break }
            return 0
        case 3:
            guard user.school.isEmpty && user.degree.isEmpty else { break }
            return 0
        case 4:
            guard user.biography.isEmpty else { break }
            return 0
        case 5: guard user.heightString.isEmpty else { break }
            return 0
        default:
            return UITableViewAutomaticDimension
        }
        return UITableViewAutomaticDimension
    }

    func tableView(tableView: UITableView,
                   estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        return 90
    }
}

class DateProposalViewModel: NSObject, ViewModelProtocol, Routable {
    let router = Router()
    var api: DateProposalApiProtocol = DateProposalApiController()
    var superDataSource: UITableViewDataSource? = nil
    var user: UserInfo
    var delegate: DateProposalRefreshDelegate? = nil
    var appNavigator: AppNavigator?

    init(appNavigator: AppNavigator?, user: UserInfo) {
        self.appNavigator = appNavigator
        self.user = user
    }

    func accept() {
        guard let username = user.username else { return }
        api.acceptDate(username) {[weak self] bothPartiesAccepted in
            if (bothPartiesAccepted) {
                self?.routeToMessages(username)
            }
            guard let user = self?.user else { return }
            self?.delegate?.actionWasTaken(user)
        }
    }

    func decline() {
        guard let username = user.username else { return }
        api.declineDate(username) {[weak self] in
            guard let user = self?.user else { return }
            self?.delegate?.actionWasTaken(user)
        }
    }
}
