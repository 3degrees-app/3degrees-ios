//
//  SwitchActionViewModelSpec.swift
//  3Degrees
//
//  Created by Gigster Developer on 6/2/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Quick
import Nimble

@testable import _Degrees

class SwitchActionViewModelSpec: QuickSpec {
    override func spec() {
        var viewModel: SwitchActionViewModel!
        var userApi: UserApiControllerMock!

        describe("switched value for open to date") {
            beforeEach {
                viewModel = SwitchActionViewModel(action: LeftMenuAction.OpenToDate)
                userApi = UserApiControllerMock()
                viewModel.userApi = userApi
            }
            it("clicked") {
                viewModel.switchValueChanged(true)
                expect(userApi.isSingleValue).to(beTrue())
                viewModel.switchValueChanged(false)
                expect(userApi.isSingleValue).to(beFalse())
            }
        }
    }
}
