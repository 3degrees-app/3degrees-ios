//
//  Moment+Extension.swift
//  3Degrees
//
//  Created by Gigster Developer on 9/5/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation
import SwiftMoment

extension Moment {
    func isSameDate(moment: Moment) -> Bool {
        return day == moment.day && month == moment.month && year == moment.year
    }

    var dateWithoutTime: Moment {
        return self.subtract(second, .Seconds)
                   .subtract(minute, .Minutes)
                   .subtract(hour, .Hours)
    }
}
