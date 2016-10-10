//
//  UsersRequestModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 8/1/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation

struct UsersRequestModel {
    let query: String
    let singlesOnly: Bool
    let limit: Int
    let page: Int
    var matchmaker: String? = nil
    var excludeMyConnections: Bool = true
}
