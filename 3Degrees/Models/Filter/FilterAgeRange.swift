//
//  FilterAgeRange.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/24/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation

struct FilterAgeRange {
    // 0 == No Min, 100 == No Max
    private static let values: [Int] = [18, 21, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 100]

    static let allLeftValues: [Int] = {
        var leftValues = FilterAgeRange.values
        leftValues.removeLast()
        return leftValues
    }()

    static let allRightValues: [Int] = {
        var rightValues = FilterAgeRange.values
        rightValues.removeFirst()
        return rightValues
    }()

    static func getReadableName(value: Int) -> String {
        switch value {
        case 100:
            return "No Max"
        default:
            return String(value)
        }
    }
}
