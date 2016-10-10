//
//  ContactSearchCellViewModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/23/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

struct ContactSearchCellViewModel: ViewModelProtocol {
    typealias InvitedHandlerType = (UserInfo) -> Void

    let contact: UserInfo
    let userType: MyNetworkTab.UsersType
    let invitedHandler: InvitedHandlerType
    let mode: ContactSearchViewModel.SearchMode
    var api: MyNetworkApiProtocol = MyNetworkApiController()
    var router: RoutingProtocol? = nil

    init(contact: UserInfo, userType: MyNetworkTab.UsersType,
         invitedHandler: InvitedHandlerType, mode: ContactSearchViewModel.SearchMode) {
        self.contact = contact
        self.userType = userType
        self.invitedHandler = invitedHandler
        self.mode = mode
    }

    func invite(uiCompletionHandler: (() -> ()) -> ()) {
        guard let username = contact.username else { return }
        api.addUser(username) {
            uiCompletionHandler {
                self.invitedHandler(self.contact)
            }
        }
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
