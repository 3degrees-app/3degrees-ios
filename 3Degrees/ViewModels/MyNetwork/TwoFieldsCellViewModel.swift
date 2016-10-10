//
//  TwoFieldsCellViewModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/17/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation

struct TwoFieldsCellViewModel: ViewModelProtocol {
    let icon: String
    let title: String
    let subtitle: String
    var router: RoutingProtocol? = nil
}
