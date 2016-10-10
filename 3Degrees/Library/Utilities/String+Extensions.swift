//
//  String+Extensions.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/1/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation

extension String {
    var birthdayNSDate: NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = Constants.Birthday.dateFormat
        let date = dateFormatter.dateFromString(self)
        return date
    }

    var trimmed: String {
        return self.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
    }
}
