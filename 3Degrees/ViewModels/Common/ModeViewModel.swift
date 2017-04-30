//
//  UserModeViewModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/5/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation
import Bond
import Router

protocol ModeViewModelProtocol {
    func handleSingleSelected()
    func handleMatchmakerSelected()
}

class ModeViewModel: FullScreenViewModelProtocol, ModeViewModelProtocol, Routable {
    var appNavigator: AppNavigator? = nil
    let router = Router()
    var userApi: UserApiProtocol = UserApiController()

    init(appNavigator: AppNavigator) {
        self.appNavigator = appNavigator
    }

    func handleSingleSelected() {
        userApi.switchIsSingle(true) {
            AppController.shared.currentUserMode.next(.Single)
            self.route(":root:/get-started")
        }
    }

    func handleMatchmakerSelected() {
        userApi.switchIsSingle(false) {
            AppController.shared.currentUserMode.next(.Matchmaker)
            self.route(":root:/get-started")
        }
    }
}
