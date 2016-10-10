//
//  HeaderCellViewModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/17/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation

struct HeaderCellViewModel: ViewModelProtocol {
    let avatar: String
    let name: String
    let info: String
    let chatButtonPressed: () -> ()
    let matchButtonPressed: () -> ()
    var router: RoutingProtocol? = nil
}
