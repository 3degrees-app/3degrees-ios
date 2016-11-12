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
    var appNavigator: AppNavigator? = nil
    let value: Moment
    let user: UserInfo
    let mode: ScheduleResultsViewController.ScreenMode

    var cellValue: String {
        return value.format("MMM dd: hh:mm a")
    }

    init(value: Moment,
         appNavigator: AppNavigator?,
         user: UserInfo,
         mode: ScheduleResultsViewController.ScreenMode) {
        self.value = value
        self.appNavigator = appNavigator
        self.user = user
        self.mode = mode
    }

    func accept() {
        guard let username = user.username else { return }
        api.acceptSuggestedDate(username, date: value.date) {
            self.appNavigator?.popAction()
        }
    }
}
