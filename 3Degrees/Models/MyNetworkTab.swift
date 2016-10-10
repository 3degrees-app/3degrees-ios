//
//  MyNetworkTab.swift
//  3Degrees
//
//  Created by Gigster Developer on 6/15/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation

enum MyNetworkTab {
    case First
    case Second

    var name: String {
        switch tabKind {
        case .Singles:
            return R.string.localizable.singlesTabName()
        case .Matchmakers:
            return R.string.localizable.matchmakerTabName()
        case .Dates:
            return R.string.localizable.datesTabName()
        }
    }

    var tabKind: UsersType {
        let userMode = AppController.shared.currentUserMode.value
        switch self {
        case .First:
            return userMode == .Single ? .Matchmakers : .Singles
        case .Second:
            return userMode == .Single ? .Dates : .Matchmakers
        }
    }

    var isSingles: Bool {
        return tabKind.isSingles
    }

    var isDate: Bool {
        return tabKind.isDate
    }

    enum UsersType {
        case Singles
        case Matchmakers
        case Dates

        var postfix: String {
            switch self {
            case .Singles, .Dates:
                return R.string.localizable.singlesInfoPostfix()
            case .Matchmakers:
                return R.string.localizable.matchmakersInfoPostfix()
            }
        }

        var reversePostfix: String {
            switch self {
            case .Matchmakers:
                return R.string.localizable.singlesInfoPostfix()
            case .Singles, .Dates:
                return R.string.localizable.matchmakersInfoPostfix()
            }
        }

        var isSingles: Bool {
            switch self {
            case .Singles, .Dates:
                return true
            case .Matchmakers:
                return false
            }
        }

        var isDate: Bool {
            switch self {
            case .Dates:
                return true
            default:
                return false
            }
        }
    }
}
