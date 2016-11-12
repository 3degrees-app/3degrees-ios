//
//  ContactViewModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/13/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

struct ContactViewModel: ViewModelProtocol {
    var appNavigator: AppNavigator? = nil
    let contact: UserInfo
    let userType: MyNetworkTab.UsersType

    init(contact: UserInfo, userType: MyNetworkTab.UsersType) {
        self.contact = contact
        self.userType = userType
    }

    var name: String {
        return contact.fullName
    }

    var avatarUrl: String {
        guard let url = contact.avatarUrl else { return "" }
        return url
    }

    var info: String {
        let count = userType.isSingles ?
            contact.userMatchmakers.count :
            contact.userSingles.count
        return "\(count) \(userType.reversePostfix.capitalizedString)"
    }
}
