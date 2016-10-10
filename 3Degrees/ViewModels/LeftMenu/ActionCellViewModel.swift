//
//  ActionCellViewModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 4/28/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation

protocol ActionCellViewModelProtocol {
    var actionName: String { get }
    init(action: LeftMenuAction)
}

class ActionCellViewModel: ActionCellViewModelProtocol, ViewModelProtocol {
    var router: RoutingProtocol?
    let action: LeftMenuAction
    var currentUserMode: Mode

    required init(action: LeftMenuAction) {
        self.action = action
        currentUserMode = AppController.shared.currentUserMode.value
    }

    var actionName: String {
        if action == .SwitchMode {
            return action.rawValue + currentUserMode.getOppositeValue().rawValue + " Mode"
        }
        return action.rawValue
    }
}
