//
//  NSDate+Birthday.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/1/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation

extension NSDate {
    var birthdayString: String {
        return getStringFromDate(Constants.Birthday.dateFormat)
    }

    var dateString: String {
        return getStringFromDate(Constants.DateProposal.DateFormat)
    }

    var dayString: String {
        return getStringFromDate(Constants.DateProposal.DayFormat)
    }

    var timeString: String {
        return  getStringFromDate(Constants.DateProposal.TimeFormat)
    }

    var monthName: String {
        return getStringFromDate("MMMM")
    }

    var chatFullDate: String {
        return getStringFromDate(Constants.Chat.MessageDateTimeFormat)
    }

    var age: Int {
        return NSCalendar.currentCalendar()
                         .components(
                            .Year,
                            fromDate: self,
                            toDate: NSDate(),
                            options: []
                         ).year

    }

    private func getStringFromDate(format: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.stringFromDate(self)
    }
}
