//
//  Mode.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/12/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation

enum Mode: String {
    case Single = "Single"
    case Matchmaker = "Matchmaker"

    func getOppositeValue() -> Mode {
        switch self {
        case .Single:
            return .Matchmaker
        case .Matchmaker:
            return .Single
        }
    }
}
