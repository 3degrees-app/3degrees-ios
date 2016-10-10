//
//  UserModeViewModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/5/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation
import Bond

protocol ModeViewModelProtocol {
    func handleSingleSelected()
    func handleMatchmakerSelected()
}

struct ModeViewModel: ViewModelProtocol, ModeViewModelProtocol {
    var router: RoutingProtocol? = nil

    func handleSingleSelected() {
        AppController.shared.setupMainAppContent()
        AppController.shared.currentUserMode.next(.Single)
    }

    func handleMatchmakerSelected() {
        AppController.shared.setupMainAppContent()
        AppController.shared.currentUserMode.next(.Matchmaker)

    }
}
