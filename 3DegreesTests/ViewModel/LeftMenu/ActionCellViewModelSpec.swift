//
//  ActionCellViewModelSpec.swift
//  3Degrees
//
//  Created by Gigster Developer on 6/2/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Quick
import Nimble

@testable import _Degrees

class ActionCellViewModelSpec: QuickSpec {
    override func spec() {
        var viewModel: ActionCellViewModel!
        describe("action cell with switch mode") {
            beforeEach {
                viewModel = ActionCellViewModel(action: .SwitchMode)
                viewModel.currentUserMode = .Single
            }
            it("has valid action name") {
                let actionName = viewModel.actionName
                expect(actionName).to(equal("\(viewModel.action.rawValue)\(viewModel.currentUserMode.getOppositeValue().rawValue) Mode"))
            }
        }
        describe("action cell with other types") {
            it("has valid action name for general types except .SwitchMode") {
                LeftMenuAction.generalActions.forEach({ (action) in
                    if action == .SwitchMode { return }
                    viewModel = ActionCellViewModel(action: action)
                    expect(viewModel.actionName).to(equal(action.rawValue))
                })
            }
        }
    }
}
