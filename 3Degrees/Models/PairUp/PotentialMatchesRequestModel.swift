//
//  PotentialMatchesRequestModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 8/17/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation
import ThreeDegreesClient

struct PotentialMatchesRequestModel {
    var username: String
    var page: Int
    var limit: Int
    var ageFrom: Int?
    var ageTo: Int?
    var gender: FilterGender?
    var matchmakerUsername: String?
    var completion: (([User]) -> ())?
}
