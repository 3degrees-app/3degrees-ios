//
//  AccountAction.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/7/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation


enum AccountAction: String {

    // MARK: General Actions
    case EditProfile = "Edit My Profile"
    case InviteMatchMaker = "Invite Matchmaker"
    case InviteSingle = "Invite Single"
    case OpenToDate = "Open to Date"
    case PushNotifications = "Push Notifications"
    case Preference = "Match Preference"
    case SwitchMode = "Switch to "
    case LogOut = "Log Out"

    static var fullGeneralActionsList:[AccountAction] = [
        .EditProfile,
        .InviteMatchMaker,
        .InviteSingle,
        //.OpenToDate,
        .Preference,
        .PushNotifications,
        //.SwitchMode,
        .LogOut
    ]

    static var matchmakerModeGeneralActionsList: [AccountAction] = [
        .EditProfile,
        .InviteMatchMaker,
        .InviteSingle,
        //.OpenToDate,
        .PushNotifications,
        //.SwitchMode,
        .LogOut
    ]

    static var singleModeGeneralActionsList: [AccountAction] = [
        .EditProfile,
        .InviteMatchMaker,
        //.OpenToDate,
        .Preference,
        .PushNotifications,
        //.SwitchMode,
        .LogOut
    ]

    static var generalActions:[AccountAction] {
        if AppController.shared.currentUserMode.value == .Matchmaker {
            return matchmakerModeGeneralActionsList
        }
        return singleModeGeneralActionsList
    }

    // MARK: Support Actions
    case FAQ = "Frequently Asked Questions"
    case ContactUs = "Contact Us"

    static var supportActions:[AccountAction] {
        return [.FAQ, .ContactUs]
    }

    // MARK: About Actions
    case PrivacyPolicy = "Privacy Policy"
    case TermsOfService = "Terms Of Service"

    static var aboutActions:[AccountAction] {
        return [.PrivacyPolicy, .TermsOfService]
    }

    static func fromStaticContentType(staticContentType: StaticContentType) -> AccountAction? {
        switch staticContentType {
        case .ContactUs:
            return AccountAction.ContactUs
        case .FAQ:
            return AccountAction.FAQ
        case .PrivacyPolicy:
            return AccountAction.PrivacyPolicy
        case .Tos:
            return AccountAction.TermsOfService
        case .UnsupportedVersion:
            return AccountAction.UnsupportedVersion
        default:
            return nil
        }
    }

    static func toStaticContentType(accountAction: AccountAction) -> StaticContentType? {
        switch accountAction {
        case .ContactUs:
            return StaticContentType.ContactUs
        case .FAQ:
            return StaticContentType.FAQ
        case .PrivacyPolicy:
            return StaticContentType.PrivacyPolicy
        case .TermsOfService:
            return StaticContentType.Tos
        case .UnsupportedVersion:
            return StaticContentType.UnsupportedVersion
        default:
            return nil
        }
    }

    // MARK: Other
    case UnsupportedVersion = "Unsupported Version"
}
