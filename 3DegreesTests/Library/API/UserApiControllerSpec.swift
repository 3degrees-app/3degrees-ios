//
//  UserApiControllerSpec.swift
//  3Degrees
//
//  Created by Gigster Developer on 6/2/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Quick
import Nimble
import ThreeDegreesClient

@testable import _Degrees

class UserApiControllerSpec: QuickSpec {
    override func spec() {
        var api: UserApiController!
        var baseApiController: BaseApiControllerMock!
        describe("user methods in case of network error") {
            beforeEach {
                api = UserApiController()
                baseApiController = BaseApiControllerMock()
                baseApiController.shoudFail = true
                api.api = baseApiController
            }
            it("should fail for all due to network error") {
                var success = false
                api.currentUser {
                    success = true
                }
                expect(success).to(beFalse())
                api.updateUser(PrivateUser()) {
                    success = true
                }
                expect(success).to(beFalse())
                api.switchIsSingle(true) {
                    success = true
                }
                expect(success).to(beFalse())
            }
        }
        describe("user methods") {
            var success: Bool!
            beforeEach {
                api = UserApiController()
                baseApiController = BaseApiControllerMock()
                api.api = baseApiController
                success = false
            }
            it("should not fail while getting user") {
                api.currentUser {
                    success = true
                }
                expect(success).to(beTrue())
            }
            it("should not fail while updating user") {
                api.updateUser(PrivateUser()) {
                    success = true
                }
                expect(success).to(beTrue())
            }
            it("should not fail while switchin is-single") {
                api.switchIsSingle(true) {
                    success = true
                }
                expect(success).to(beTrue())
            }
        }
    }
}
