//
//  FilterDistance.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/24/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation

enum FilterDistance: String {
    case NoMax = "No Max"
    case Five = "5 Miles"
    case Fifteen = "15 Miles"
    case Thirty = "30 Miles"
    case Fifty = "50 Miles"
    case OneHundred = "100 Miles"

    static let allValues:[FilterDistance] = [.NoMax, .Five, .Fifteen, .Thirty, .Fifty, .OneHundred]
}
