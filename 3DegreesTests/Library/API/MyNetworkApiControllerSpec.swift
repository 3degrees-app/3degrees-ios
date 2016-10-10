//
//  MyNetworkApiControllerSpec.swift
//  3Degrees
//
//  Created by Gigster Developer on 6/3/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Quick
import Nimble
import ThreeDegreesClient

@testable import _Degrees

class MyNetworkAPiControllerSpec: QuickSpec {
    

    override func spec() {
        var apiController: MyNetworkApiController!
        var baseApi: BaseApiControllerMock!

        describe("my network api") {
            beforeEach {
                apiController = MyNetworkApiController()
                baseApi = BaseApiControllerMock()
                apiController.api = baseApi
            }
            it("gets singles") {
                var completedSuccessfully: Bool = false
                apiController.getSingles(0, limit: 100, completion: { (singles) in
                    completedSuccessfully = true
                })
                expect(completedSuccessfully).to(beTrue())
                baseApi.shoudFail = true
                apiController.api = baseApi
                completedSuccessfully = false
                apiController.getSingles(0, limit: 100) { (singles) in
                    completedSuccessfully = true
                }
                expect(completedSuccessfully).to(beFalse())
            }
            it("gets matchmakers") {
                var completedSuccessfully: Bool = false
                apiController.getMatchmakers(0, limit: 100) { (mms) in
                    completedSuccessfully = true
                }
                expect(completedSuccessfully).to(beTrue())
                baseApi.shoudFail = true
                apiController.api = baseApi
                completedSuccessfully = false
                apiController.getMatchmakers(0, limit: 100) {(mmss) in
                    completedSuccessfully = true
                }
                expect(completedSuccessfully).to(beFalse())
            }
            it("deletes connection") {
                var completedSuccessfully = false
                apiController.deleteConnection("") {
                    completedSuccessfully = true
                }
                expect(completedSuccessfully).to(beTrue())
                completedSuccessfully = false
                baseApi.shoudFail = true
                apiController.api = baseApi
                apiController.deleteConnection("") {
                    completedSuccessfully = true
                }
                expect(completedSuccessfully).to(beFalse())
            }
            it("get users") {
                var completedSuccessfully = false
                var requestModel = UsersRequestModel(query: "query",
                                                     singlesOnly: true,
                                                     limit: 10,
                                                     page: 0,
                                                     excludeMyConnections: true)
                apiController.getUsers(requestModel) { (users) in
                    completedSuccessfully = true
                }
                expect(completedSuccessfully).to(beTrue())
                completedSuccessfully = false
                baseApi.shoudFail = true
                apiController.api = baseApi
                requestModel = UsersRequestModel(query: "query",
                                                 singlesOnly: false,
                                                 limit: 10,
                                                 page: 0,
                                                 excludeMyConnections: true)
                apiController.getUsers(requestModel) { (users) in
                    completedSuccessfully = true
                }
                expect(completedSuccessfully).to(beFalse())
            }
            it("add user") {
                var completedSuccessfully = false
                apiController.addUser("") {
                    completedSuccessfully = true
                }
                expect(completedSuccessfully).to(beTrue())
                completedSuccessfully = false
                baseApi.shoudFail = true
                apiController.api = baseApi
                apiController.addUser("") {
                    completedSuccessfully = true
                }
                expect(completedSuccessfully).to(beFalse())
            }
            it("get messages") {
                var completedSuccessfully = false
                apiController.getMessages("", page: 0, limit: 0) {(messages) in
                    completedSuccessfully = true
                }
                expect(completedSuccessfully).to(beTrue())
                completedSuccessfully = false
                baseApi.shoudFail = true
                apiController.api = baseApi
                apiController.getMessages("", page: 0, limit: 0) {(messages) in
                    completedSuccessfully = true
                }
                expect(completedSuccessfully).to(beFalse())
            }
            it("send message") {
                var completedSuccessfully = false
                apiController.sendMessage("", message: Message()) {
                    completedSuccessfully = true
                }
                expect(completedSuccessfully).to(beTrue())
                completedSuccessfully = false
                baseApi.shoudFail = true
                apiController.api = baseApi
                apiController.sendMessage("", message: Message()) {
                    completedSuccessfully = true
                }
                expect(completedSuccessfully).to(beFalse())
            }
        }
    }
}