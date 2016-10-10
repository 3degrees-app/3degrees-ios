//
//  Preference.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/4/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation
import ThreeDegreesClient

enum UserPreference: String {
    case Men = "Only Men"
    case Women = "Only Women"
    case Both = "Women and Men"

    static let allValues:[UserPreference] = [.Men, .Women, .Both]

    func getGender() -> PrivateUser.MatchWithGender? {
        switch self {
        case .Men:
            return PrivateUser.MatchWithGender.Male
        case .Women:
            return PrivateUser.MatchWithGender.Female
        default:
            return nil
        }
    }

    static func getPreference(gender: PrivateUser.MatchWithGender?) -> UserPreference {
        guard let gender = gender else { return .Both }
        switch gender {
        case .Male:
            return .Men
        case .Female:
            return .Women
        }
    }
}
