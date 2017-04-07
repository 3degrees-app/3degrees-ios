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

class ModeViewModel: ViewModelProtocol, ModeViewModelProtocol, Routable {
    var appNavigator: AppNavigator? = nil
    let router = Router()

    init(appNavigator: AppNavigator) {
        self.appNavigator = appNavigator
    }

    func handleSingleSelected() {
        AppController.shared.currentUserMode.next(.Single)
        self.route("/get-started")
    }

    func handleMatchmakerSelected() {
        AppController.shared.currentUserMode.next(.Matchmaker)
        self.route("/get-started")
    }
}
