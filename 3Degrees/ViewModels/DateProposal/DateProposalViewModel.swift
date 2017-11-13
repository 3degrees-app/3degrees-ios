//
//  DateProposalViewModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/8/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Bond
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
    var activityApi: ActivityApiProtocol = ActivityApiController()
    var superDataSource: UITableViewDataSource? = nil
    var user: UserInfo
    var suggestedBy:Observable<UserInfo?> = Observable(nil)
    var iAmConnected: Observable<Bool> = Observable(false)
    var delegate: DateProposalRefreshDelegate? = nil
    var appNavigator: AppNavigator?
    private var myMatchmakers: Observable<[UserInfo]>

    init(appNavigator: AppNavigator?, match: Match, myMatchmakers: Observable<[UserInfo]>) {
        self.appNavigator = appNavigator
        self.user = match.user!
        self.myMatchmakers = myMatchmakers
        super.init()
        self.activityApi.getUser(match.matchmakerUsername!, completion: { [unowned self] matchmaker in
            self.suggestedBy.next(matchmaker)
        })
        self.myMatchmakers.observe { [unowned self] matchmakers in
            self.setIAmConnected(self.suggestedBy.value, matchmakers: matchmakers)
        }
        self.suggestedBy.observe { [unowned self] suggestedBy in
            self.setIAmConnected(suggestedBy, matchmakers: self.myMatchmakers.value)
        }
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
    
    private func setIAmConnected(matcherOpt: UserInfo?, matchmakers: [UserInfo]) {
        if let matcher = matcherOpt, let _ = matchmakers.filter({ $0.username == matcher.username }).first {
            self.iAmConnected.next(true)
        } else {
            self.iAmConnected.next(false)
        }
    }
}
