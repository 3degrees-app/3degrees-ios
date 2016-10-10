//
//  PrivateUser+FormattedInfo.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/2/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation
import ThreeDegreesClient

extension PrivateUser {
    var userInfo: String {
        var userInfo: String = ""
        let age = getAge()
        userInfo += String(age)
        if let gender = self.gender {
            let genderShort = String(gender.rawValue.characters.first!)
            userInfo += ", " + genderShort.capitalizedString
        }
        let locationInfo = getLocationInfo()
        userInfo += locationInfo.isEmpty ? "" : ", " + locationInfo
        return userInfo
    }

    var name: String {
        return getUserFullName()
    }

    var formattedLocation: String {
        return getLocationInfo()
    }

    private func getLocationInfo() -> String {
        var location: String = ""
        if let city = self.location?.city where !city.isEmpty {
            location += city.trimmed
        }
        if let state = self.location?.state where !state.isEmpty {
            location += ", " + state.trimmed
        }
        if let country = self.location?.country where !country.isEmpty {
            location += ", " + country.trimmed
        }
        return location
    }

    private func getUserFullName() -> String {
        var name: String = ""
        guard let fName = self.firstName else { return name }
        name += fName
        guard let lName = self.lastName else { return name }
        name += name.isEmpty ? lName : " " + lName
        return name
    }

    private func getAge() -> Int {
        guard let dob = self.dob else { return 0 }
        return NSCalendar.currentCalendar()
                         .components(
                            .Year,
                            fromDate: dob,
                            toDate: NSDate(),
                            options: [])
                         .year
    }
}
