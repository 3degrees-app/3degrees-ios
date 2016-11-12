//
//  ProposedPersonCellViewModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/20/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation
import ThreeDegreesClient

struct ProposedPersonCellViewModel: ViewModelProtocol {
    var appNavigator: AppNavigator? = nil
    let person: UserInfo

    init(person: UserInfo) {
        self.person = person
    }
}
