//
//  Height+Formats.swift
//  3Degrees
//
//  Created by Ryan Martin on 11/5/17.
//  Copyright © 2017 Gigster. All rights reserved.
//

import Foundation
import ThreeDegreesClient

extension Height {
    var prettyString: String {
        switch self.unit! {
        case Unit.Cm:
            return String(self.amount! / 100) + " m"
        case Unit.In:
            return String(Int(self.amount! / 12)) + "' " + String(self.amount! % 12) + "\""
        }
    }
}
