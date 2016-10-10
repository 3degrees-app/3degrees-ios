//
//  ProposedDatesDescriptionCellViewModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 9/4/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation

struct ProposedDatesDescriptionCellViewModel: ViewModelProtocol {
    var router: RoutingProtocol? = nil

    let mode: ScheduleResultsViewController.ScreenMode

    init(mode: ScheduleResultsViewController.ScreenMode) {
        self.mode = mode
    }

    var description: String {
        switch mode {
        case .Choose:
            return R.string.localizable.chooseDateTimeDescription()
        default:
            return R.string.localizable.acceptDateTimeDescription()
        }
    }
}
