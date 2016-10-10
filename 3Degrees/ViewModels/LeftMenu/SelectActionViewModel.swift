//
//  SelectActionViewModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/7/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation
import Bond

protocol SelectActionViewModelProtocol {
    var actionName: String { get }
    var observableValue: Observable<String?> { get }
    init(action: LeftMenuAction, value: Observable<String?>)
}

struct SelectActionViewModel: ViewModelProtocol, SelectActionViewModelProtocol {
    var router: RoutingProtocol? = nil
    let action: LeftMenuAction
    let observableVal: Observable<String?>

    init(action: LeftMenuAction, value: Observable<String?>) {
        self.action = action
        self.observableVal = value
    }

    var actionName: String {
        return action.rawValue
    }

    var observableValue: Observable<String?> {
        return observableVal
    }
}
