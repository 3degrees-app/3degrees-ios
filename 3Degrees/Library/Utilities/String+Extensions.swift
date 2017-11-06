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

    func capturedGroups(pattern: String) -> [String] {
        var results = [String]()
        
        var regex: NSRegularExpression
        do {
            regex = try NSRegularExpression(pattern: pattern, options: [])
        } catch {
            return results
        }
        
        let matches = regex.matchesInString(self, options: [], range: NSRange(location:0, length: self.characters.count))
        
        guard let match = matches.first else { return results }
        
        let lastRangeIndex = match.numberOfRanges - 1
        guard lastRangeIndex >= 1 else { return results }
        
        for i in 1...lastRangeIndex {
            let capturedGroupIndex = match.rangeAtIndex(i)
            let matchedString = (self as NSString).substringWithRange(capturedGroupIndex)
            results.append(matchedString)
        }
        
        return results
    }
}
