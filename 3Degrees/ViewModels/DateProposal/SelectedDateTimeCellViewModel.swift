//
//  SelectedDateTimeCellViewModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 9/4/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import SwiftMoment

struct SelectedDateTimeCellViewModel: ViewModelProtocol {
    var api: DateProposalApiProtocol = DateProposalApiController()
    var router: RoutingProtocol? = nil
    let value: Moment
    let user: UserInfo
    let mode: ScheduleResultsViewController.ScreenMode

    var cellValue: String {
        return value.format("MMM dd: hh:mm a")
    }

    init(value: Moment,
         router: RoutingProtocol?,
         user: UserInfo,
         mode: ScheduleResultsViewController.ScreenMode) {
        self.value = value
        self.router = router
        self.user = user
        self.mode = mode
    }

    func accept() {
        guard let username = user.username else { return }
        api.acceptSuggestedDate(username, date: value.date) {
            self.router?.popAction()
        }
    }
}
