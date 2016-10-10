//
//  StaticContentApiControllerSpec.swift
//  3Degrees
//
//  Created by Gigster Developer on 6/2/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Quick
import Nimble

@testable import _Degrees

class StaticContentApiControllerSpec: QuickSpec {
    override func spec() {
        var api: StaticContentApiController!
        var baseApiController: BaseApiControllerMock!

        describe("get static content") {
            beforeEach {
                api = StaticContentApiController()
                baseApiController = BaseApiControllerMock()
                api.api = baseApiController
            }
            it("should fail due to network error") {
                baseApiController.shoudFail = true
                api.api = baseApiController
                var success = false
                api.getWithType(.FAQ, completion: { (content) in
                    success = true
                })
                expect(success).to(beFalse())
                api.getWithType(.PrivacyPolicy, completion: { (content) in
                    success = true
                })
                expect(success).to(beFalse())
                api.getWithType(.Tos, completion: { (content) in
                    success = true
                })
                expect(success).to(beFalse())
            }
            it("should return content") {
                var success = false
                api.getWithType(.FAQ, completion: { (content) in
                    success = content != nil
                })
                expect(success).to(beTrue())
                api.getWithType(.PrivacyPolicy, completion: { (content) in
                    success = content != nil
                })
                expect(success).to(beTrue())
                api.getWithType(.Tos, completion: { (content) in
                    success = content != nil
                })
                expect(success).to(beTrue())
            }
        }
    }
}

