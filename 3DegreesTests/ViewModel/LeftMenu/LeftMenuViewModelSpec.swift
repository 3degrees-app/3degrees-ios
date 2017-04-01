//
//  AccountViewModelSpec.swift
//  3Degrees
//
//  Created by Gigster Developer on 6/2/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Quick
import Nimble
import ThreeDegreesClient

@testable import _Degrees

class AccountViewModelSpec: QuickSpec {
    override func spec() {
        var viewModel: AccountViewModel!
        var router: RouterMock!
        var userApi: UserApiControllerMock!
        var authApi: AuthApiControllerMock!
        var staticContentApi: StaticContentApiControllerMock!
        var tableViewMock: TableViewMock!


        describe("invite new user") {
            beforeEach {
                router = RouterMock()
                tableViewMock = TableViewMock()
                viewModel = AccountViewModel(actionTableView: tableViewMock, router: router)
                userApi = UserApiControllerMock()
                authApi = AuthApiControllerMock()
                staticContentApi = StaticContentApiControllerMock()
                viewModel.userApi = userApi
                viewModel.authApi = authApi
                viewModel.staticContentApi = staticContentApi
            }
            it("fails on simulator and runs on device") {
                let canSendMessage = viewModel.canInviteViaSms
            #if (arch(i386) || arch(x86_64))
                expect(canSendMessage).to(beFalse())
                viewModel.handleInviteUser("")
                expect(router.presentedViewController).to(beFalse())
            #else
                expect(canSendMessage).to(beTrue())
                viewModel.handleInviteUser("")
                expect(router.presentedViewController).to(beTrue())
            #endif
            }
        }
        describe("observing current user and mode") {
            beforeEach {
                router = RouterMock()
                tableViewMock = TableViewMock()
                viewModel = AccountViewModel(actionTableView: tableViewMock, router: router)
                userApi = UserApiControllerMock()
                authApi = AuthApiControllerMock()
                staticContentApi = StaticContentApiControllerMock()
                viewModel.userApi = userApi
                viewModel.authApi = authApi
                viewModel.staticContentApi = staticContentApi
            }
            it("gets mode chaged notification and switch mode row should be update") {
                let mode: Mode = .Single
                viewModel.observeModeChanges(mode)
                expect(tableViewMock.reloaded) == true
            }
            context("gets user changed notification") {
                it("should extract full name and user info") {
                    let user = PrivateUser()
                    user.firstName = "fname"
                    user.lastName = "lname"

                    var fullName = ""
                    var userInfo = ""

                    viewModel.observableName.observeNew { fullName = $0! }
                    viewModel.observableUserInfo.observeNew { userInfo = $0! }

                    viewModel.observeUserChanges(user)
                    expect(fullName).to(equal(user.name))
                    expect(userInfo).to(equal(user.userInfo))
                }
            }
        }
        describe("selected user preference value handling") {
            beforeEach {
                router = RouterMock()
                tableViewMock = TableViewMock()
                viewModel = AccountViewModel(actionTableView: tableViewMock, router: router)
                userApi = UserApiControllerMock()
                authApi = AuthApiControllerMock()
                staticContentApi = StaticContentApiControllerMock()
                viewModel.userApi = userApi
                viewModel.authApi = authApi
                viewModel.staticContentApi = staticContentApi
            }
            it("changed value to empty or invalid string") {
                var value: String? = nil
                viewModel.observablePreference.observeNew { value = $0! }
                viewModel.valueSelected("")
                expect(value).to(beNil())
                viewModel.valueSelected("blabla")
                expect(value).to(beNil())
            }
            it("changed value to correct string") {
                var value: String? = nil
                viewModel.observablePreference.observeNew { value = $0! }
                viewModel.valueSelected(UserPreference.Both.rawValue)
                expect(value).to(equal(UserPreference.Both.rawValue))
                viewModel.valueSelected(UserPreference.Men.rawValue)
                expect(value).to(equal(UserPreference.Men.rawValue))
                viewModel.valueSelected(UserPreference.Women.rawValue)
                expect(value).to(equal(UserPreference.Women.rawValue))
            }
        }
        describe("loading current user") {
            beforeEach {
                router = RouterMock()
                tableViewMock = TableViewMock()
                viewModel = AccountViewModel(actionTableView: tableViewMock, router: router)
                userApi = UserApiControllerMock()
                authApi = AuthApiControllerMock()
                staticContentApi = StaticContentApiControllerMock()
                viewModel.userApi = userApi
                viewModel.authApi = authApi
                viewModel.staticContentApi = staticContentApi
            }
            it("updates current preference") {
                var newPreference: String? = nil
                viewModel.observablePreference.observeNew {
                    newPreference = $0
                }
                let user = PrivateUser()
                user.matchWithGender = PrivateUser.MatchWithGender.Female
                AppController.shared.currentUser.next(user)
                viewModel.loadCurrentUser()
                expect(newPreference).to(equal(UserPreference.Women.rawValue))
            }
            it("updates current preference with empty value and should be .Both") {
                var newPreference: String? = nil
                viewModel.observablePreference.observeNew {
                    newPreference = $0
                }
                let user = PrivateUser()
                AppController.shared.currentUser.next(user)
                viewModel.loadCurrentUser()
                expect(newPreference).to(equal(UserPreference.Both.rawValue))
            }
        }
        describe("actions table view delegate") {
            context("general action") {
                beforeEach {
                    router = RouterMock()
                    tableViewMock = TableViewMock()
                    viewModel = AccountViewModel(actionTableView: tableViewMock, router: router)
                    userApi = UserApiControllerMock()
                    authApi = AuthApiControllerMock()
                    staticContentApi = StaticContentApiControllerMock()
                    viewModel.userApi = userApi
                    viewModel.authApi = authApi
                    viewModel.staticContentApi = staticContentApi
                }
                it("did select edit profile") {
                    let indexOfAction = AccountAction.generalActions.indexOf(.EditProfile)!
                    viewModel.handleGeneralAction(indexOfAction, actions: AccountAction.generalActions)
                    let id = R.segue.accountViewController.toEdit.identifier
                    expect(router.showedVcWithId).to(equal(id))
                }
                it("did select logout") {
                    let indexOfAction = AccountAction.generalActions.indexOf(.LogOut)!
                    viewModel.handleGeneralAction(indexOfAction, actions: AccountAction.generalActions)
                    let vc = (UIApplication.sharedApplication().keyWindow?.rootViewController as! UINavigationController).topViewController
                    expect(vc).to(beAnInstanceOf(SignUpModeViewController))
                }
                it("did select switching mode") {
                    let indexOfAction = AccountAction.generalActions.indexOf(.SwitchMode)!
                    let oldModeValue = AppController.shared.currentUserMode.value
                    viewModel.handleGeneralAction(indexOfAction, actions: AccountAction.generalActions)
                    let newModeValue = AppController.shared.currentUserMode.value
                    expect(oldModeValue).toNot(equal(newModeValue))
                }
                it("did select select preference row") {
                    let indexOfAction = AccountAction.generalActions.indexOf(.Preference)!
                    viewModel.handleGeneralAction(indexOfAction, actions: AccountAction.generalActions)
                    let segueId = R.segue.accountViewController.toSelectPreferene.identifier
                    expect(router.showedVcWithId).to(equal(segueId))
                }
                it("did select somehow not general action") {
                    let indexOfAction = AccountAction.supportActions.indexOf(.FAQ)!
                    viewModel.handleGeneralAction(indexOfAction, actions: AccountAction.supportActions)
                    expect(router.showedVcWithId).to(equal(""))
                    expect(router.presentedViewController).to(beFalse())
                }
            }
            context("support action") {
                beforeEach {
                    router = RouterMock()
                    tableViewMock = TableViewMock()
                    viewModel = AccountViewModel(actionTableView: tableViewMock, router: router)
                    userApi = UserApiControllerMock()
                    authApi = AuthApiControllerMock()
                    staticContentApi = StaticContentApiControllerMock()
                    viewModel.userApi = userApi
                    viewModel.authApi = authApi
                    viewModel.staticContentApi = staticContentApi
                }
                it("did select faq") {
                    let indexOfAction = AccountAction.supportActions.indexOf(.FAQ)!
                    viewModel.handleSupportAction(indexOfAction, actions: AccountAction.supportActions)
                    let segueId = R.segue.accountViewController.toStaticContent.identifier
                    expect(router.showedVcWithId).to(equal(segueId))
                }
                it("did select somehow not support action") {
                    let indexOfAction = AccountAction.generalActions.indexOf(.Preference)!
                    viewModel.handleSupportAction(indexOfAction, actions: AccountAction.generalActions)
                    expect(router.showedVcWithId).to(equal(""))
                    expect(router.presentedViewController).to(beFalse())
                }

            }
            context("about action") {
                beforeEach {
                    router = RouterMock()
                    tableViewMock = TableViewMock()
                    viewModel = AccountViewModel(actionTableView: tableViewMock, router: router)
                    userApi = UserApiControllerMock()
                    authApi = AuthApiControllerMock()
                    staticContentApi = StaticContentApiControllerMock()
                    viewModel.userApi = userApi
                    viewModel.authApi = authApi
                    viewModel.staticContentApi = staticContentApi
                }
                it("did select TOS") {
                    let indexOfAction = AccountAction.aboutActions.indexOf(.TermsOfService)!
                    viewModel.handleAboutAction(indexOfAction, actions: AccountAction.aboutActions)
                    let segueId = R.segue.accountViewController.toStaticContent.identifier
                    expect(router.showedVcWithId).to(equal(segueId))
                }
                it("did select privacy policy") {
                    let indexOfAction = AccountAction.aboutActions.indexOf(.TermsOfService)!
                    viewModel.handleAboutAction(indexOfAction, actions: AccountAction.aboutActions)
                    let segueId = R.segue.accountViewController.toStaticContent.identifier
                    expect(router.showedVcWithId).to(equal(segueId))
                }
                it("did select somehow not about action") {
                    let indexOfAction = AccountAction.supportActions.indexOf(.FAQ)!
                    viewModel.handleSupportAction(indexOfAction, actions: AccountAction.generalActions)
                    expect(router.showedVcWithId).to(equal(""))
                    expect(router.presentedViewController).to(beFalse())
                }
            }
        }
        describe("table view data source") {
            beforeEach {
                router = RouterMock()
                let vc = R.storyboard.userProfileScene.accountViewController()!
                _ = vc.view
                viewModel = AccountViewModel(actionTableView: vc.actionTableView, router: router)
                userApi = UserApiControllerMock()
                authApi = AuthApiControllerMock()
                staticContentApi = StaticContentApiControllerMock()
                viewModel.userApi = userApi
                viewModel.authApi = authApi
                viewModel.staticContentApi = staticContentApi
            }
            it("calls get general cell") {
                viewModel.menuMode = .General
                viewModel.menuMode.actions.enumerate().forEach { (index, action) in
                    let cell = viewModel.tableView(viewModel.actionsTableView, cellForRowAtIndexPath: NSIndexPath(forRow: index, inSection: 0))
                    switch action {
                    case .PushNotifications:
                        expect(cell).to(beAnInstanceOf(SwitchActionTableViewCell))
                        break
                    case .Preference:
                        expect(cell).to(beAnInstanceOf(SelectActionTableViewCell))
                        break
                    case .OpenToDate:
                        expect(cell).to(beAnInstanceOf(SwitchActionTableViewCell))
                        break
                    default:
                        expect(cell).to(beAnInstanceOf(ActionTableViewCell))
                    }
                }
            }
            it("calls get about cell") {
                viewModel.menuMode = .About
                viewModel.menuMode.actions.enumerate().forEach { (index, action) in
                    let cell = viewModel.tableView(viewModel.actionsTableView, cellForRowAtIndexPath: NSIndexPath(forRow: index, inSection: 0))
                    switch action {
                    case .PushNotifications:
                        expect(cell).to(beAnInstanceOf(SwitchActionTableViewCell))
                        break
                    case .Preference:
                        expect(cell).to(beAnInstanceOf(SelectActionTableViewCell))
                        break
                    case .OpenToDate:
                        expect(cell).to(beAnInstanceOf(SwitchActionTableViewCell))
                        break
                    default:
                        expect(cell).to(beAnInstanceOf(ActionTableViewCell))
                    }
                }
            }
            it("calls get support cell") {
                viewModel.menuMode = .Support
                viewModel.menuMode.actions.enumerate().forEach { (index, action) in
                    let cell = viewModel.tableView(viewModel.actionsTableView, cellForRowAtIndexPath: NSIndexPath(forRow: index, inSection: 0))
                    switch action {
                    case .PushNotifications:
                        expect(cell).to(beAnInstanceOf(SwitchActionTableViewCell))
                        break
                    case .Preference:
                        expect(cell).to(beAnInstanceOf(SelectActionTableViewCell))
                        break
                    case .OpenToDate:
                        expect(cell).to(beAnInstanceOf(SwitchActionTableViewCell))
                        break
                    default:
                        expect(cell).to(beAnInstanceOf(ActionTableViewCell))
                    }
                }
            }
        }
    }
}
