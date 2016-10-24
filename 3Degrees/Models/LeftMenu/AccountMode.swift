//
//  AccountMode.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/7/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation

enum AccountMode: String {
    case General = "General"
    case Support = "Support"
    case About = "About"

    var actions:[AccountAction] {
        switch self {
        case .About:
            return AccountAction.aboutActions
        case .Support:
            return AccountAction.supportActions
        case .General:
            return AccountAction.generalActions
        }
    }
}
