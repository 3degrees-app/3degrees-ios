//
//  FilterGender.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/24/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation

enum FilterGender: String {
    case Male = "Male"
    case Female = "Female"
    case Both = "Male and Female"

    static let allValues: [FilterGender] = [.Male, .Female, .Both]
}
