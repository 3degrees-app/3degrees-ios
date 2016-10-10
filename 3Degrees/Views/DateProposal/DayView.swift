//
//  DayView.swift
//  3Degrees
//
//  Created by Gigster Developer on 9/5/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import JTAppleCalendar
import SwiftMoment

class DayView: JTAppleDayCellView {

    @IBOutlet weak var dayLabel: DetailScheduleItemView!

    func configureBeforeDisplay(cellState: CellState, date: Moment, isSelected: Bool) {
        dayLabel.applyDefaultStyle()
        dayLabel.text = date.format("dd")
        dayLabel.layoutIfNeeded()
        if cellState.isSelected || isSelected {
            dayLabel.applySelectedStyle()
        }
        let nowMoment = moment()
        if (!date.isSameDate(nowMoment) && date < nowMoment) ||
           cellState.dateBelongsTo != .ThisMonth {
            dayLabel.applyDisabledStyle()
            self.userInteractionEnabled = false
        } else {
            self.userInteractionEnabled = true
        }
    }
}
