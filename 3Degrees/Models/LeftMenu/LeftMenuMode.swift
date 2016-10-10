//
//  LeftMenuMode.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/7/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation

enum LeftMenuMode: String {
    case General = "General"
    case Support = "Support"
    case About = "About"

    var actions:[LeftMenuAction] {
        switch self {
        case .About:
            return LeftMenuAction.aboutActions
        case .Support:
            return LeftMenuAction.supportActions
        case .General:
            return LeftMenuAction.generalActions
        }
    }
}
