//
//  UserInfo.swift
//  3Degrees
//
//  Created by Gigster Developer on 6/3/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation
import ThreeDegreesClient

protocol UserInfo {
    var fullName: String { get }
    var firstName: String? { get }
    var lastName: String? { get }
    var info: String { get }
    var degree: String { get }
    var school: String { get }
    var biography: String { get }
    var title: String { get }
    var placeOfWork: String { get }
    var matchmakerInfo: String { get }

    var userMatchmakers: [UserInfo] { get }
    var userSingles: [UserInfo] { get }

    var username: String? { get }
    var avatarUrl: String? { get }
}

extension UserInfo {
    var fullName: String { return "" }
    var firstName: String? { return "" }
    var lastName: String? { return "" }
    var info: String { return "" }
    var degree: String { return "" }
    var school: String { return "" }
    var biography: String { return "" }
    var title: String { return "" }
    var placeOfWork: String { return "" }
    var matchmakerInfo: String { return "" }
    var userSingles: [UserInfo] { return [] }

    var userMatchmakers: [UserInfo] { return [] }

    var avatarUrl: String? { return "" }
}

extension BaseUser: UserInfo {
    var fullName: String {
        var fullName: String = ""
        guard let firstName = firstName else { return fullName }
        fullName += firstName.isEmpty ? "" : firstName
        guard let lastName = lastName else { return fullName }
        fullName += lastName.isEmpty ? "" : " \(lastName)"
        return fullName.trimmed
    }

    var avatarUrl: String? { return self.image }
}

extension User: UserInfo {
    var fullName: String {
        var fullName: String = ""
        guard let firstName = firstName else { return fullName }
        fullName += firstName.isEmpty ? "" : firstName
        guard let lastName = lastName else { return fullName }
        fullName += lastName.isEmpty ? "" : " \(lastName)"
        return fullName.trimmed
    }

    var age: String {
        guard let age = self.dob?.age else { return "" }
        if age > 0 {
            return String(age)
        } else {
            return ""
        }
    }
    
    var degree: String {
        guard let degree = self.education?.degree else { return "" }
        return degree.trimmed
    }

    var city: String {
        guard let city = self.location?.city else { return "" }
        return city.trimmed
    }

    var cityState: String {
        if (self.city != "" && self.state != "") {
            return self.city + ", " + self.state
        } else {
            return self.city + self.state
        }
    }

    var state: String {
        guard let state = self.location?.state else { return "" }
        return state.trimmed
    }

    var info: String {
        if (age != "" && cityState != "") {
            return age + " | " + cityState
        } else {
            return age + cityState
        }
    }

    var school: String {
        guard let school = self.education?.school else { return "" }
        return school.trimmed
    }

    var biography: String {
        guard let biography = self.bio else { return "" }
        return biography.trimmed
    }

    var title: String {
        guard let title = self.employment?.title else { return "" }
        return title.trimmed
    }

    var placeOfWork: String {
        guard let placeOfWork = self.employment?.company else { return "" }
        return placeOfWork.trimmed
    }

    var userSingles: [UserInfo] {
        guard let singles = singles else { return [] }
        return singles.flatMap { $0 as UserInfo }
    }

    var userMatchmakers: [UserInfo] {
        guard let matchmakers = matchmakers else { return [] }
        return matchmakers.flatMap { $0 as UserInfo }
    }

    var matchmakerInfo: String {
        guard let matchmakers = self.matchmakers where !matchmakers.isEmpty else { return "" }
        return matchmakers[0].fullName.trimmed
    }


    var avatarUrl: String? {
        return self.image
    }
}
