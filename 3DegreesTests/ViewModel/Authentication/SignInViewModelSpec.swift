//
//  SignInViewModelSpec.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/25/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Quick
import Nimble
import LKAlertController
import UIKit
import Rswift

@testable import _Degrees

class SignInViewModelSpec: QuickSpec {
    override func spec() {
        describe("Facebook Login Delegate") {
            var signInViewModel: SignInViewModel!
            var mockRouter: RouterMock!
            var networkControllerMock: AuthApiControllerMock!

            beforeEach {
                mockRouter = RouterMock()
                signInViewModel = SignInViewModel(router: mockRouter)
                networkControllerMock = AuthApiControllerMock()
                signInViewModel.apiController = networkControllerMock
                LKAlertController.overrideShowForTesting({
                    (style, title, message, actions, fields) in
                    mockRouter.presentedViewController = true
                })
                networkControllerMock.shouldError = false
            }
            it("completes with token error") {
                signInViewModel.handleSuccessLogin("")
                let segueId = R.segue.signInViewController.toModeSelection.identifier
                expect(mockRouter.showedVcWithId).toNot(equal(segueId))
            }
            it("completes with server error") {
                networkControllerMock.shouldError = true
                signInViewModel.apiController = networkControllerMock
                signInViewModel.handleSuccessLogin("correct_token")
                let segueId = R.segue.signInViewController.toModeSelection.identifier
                expect(mockRouter.showedVcWithId).toNot(equal(segueId))
            }
            it("completes successfully") {
                signInViewModel.handleSuccessLogin("correct_token")
                let expectedSegue = R.segue.signInViewController.toModeSelection.identifier
                expect(mockRouter.showedVcWithId).to(equal(expectedSegue))
            }
            it("completes with facebook error") {
                let fbError = FacebookLoginError.FbError(description: "error")
                signInViewModel.handleError(fbError)
                expect(mockRouter.presentedViewController).to(equal(true))
            }
            it("completes with canceled facebook dialog") {
                let fbError = FacebookLoginError.Cancelled
                signInViewModel.handleError(fbError)
                expect(mockRouter.presentedViewController).to(beFalse())
            }
        }
        describe("signing in with login/pass") {
            var signInViewModel: SignInViewModel!
            var mockRouter: RouterMock!
            var networkControllerMock: AuthApiControllerMock!
            beforeEach {
                mockRouter = RouterMock()
                networkControllerMock = AuthApiControllerMock()
                signInViewModel = SignInViewModel(router: mockRouter)
                signInViewModel.apiController = networkControllerMock
                LKAlertController.overrideShowForTesting({
                    (style, title, message, actions, fields) in
                    mockRouter.presentedViewController = true
                })
            }
            it("should fail for empty login") {
                signInViewModel.email = nil
                signInViewModel.password = "password"
                signInViewModel.signIn()
                let segueId = R.segue.signInViewController.toModeSelection.identifier
                expect(mockRouter.showedVcWithId).toNot(equal(segueId))
            }
            it("should fail for empty pass") {
                signInViewModel.email = "email"
                signInViewModel.password = nil
                signInViewModel.signIn()
                let segueId = R.segue.signInViewController.toModeSelection.identifier
                expect(mockRouter.showedVcWithId).toNot(equal(segueId))
            }
            it("should fail with network error") {
                networkControllerMock.shouldError = true
                signInViewModel.apiController = networkControllerMock
                signInViewModel.signIn()
                let segueId = R.segue.signInViewController.toModeSelection.identifier
                expect(mockRouter.showedVcWithId).toNot(equal(segueId))
            }
            it("should complete successfully") {
                signInViewModel.email = "email@email.com"
                signInViewModel.password = "password"
                signInViewModel.signIn()
                let expectedSegue = R.segue.signInViewController.toModeSelection.identifier
                expect(mockRouter.showedVcWithId).to(equal(expectedSegue))
            }
        }
        describe("showing forgot password dialog") {
            let signInViewModel: SignInViewModel = SignInViewModel(router: RouterMock())
            it("should show alert with text field and button") {
                var alertShown: Bool = false
                LKAlertController.overrideShowForTesting({
                    (style, title, message, actions, fields) in
                    alertShown = true
                    expect(style).to(equal(UIAlertControllerStyle.Alert))
                    expect(actions).to(haveCount(2))
                    expect(fields).to(haveCount(1))
                })
                signInViewModel.showForgotPassDialog()
                expect(alertShown).to(beTrue())
            }
        }
    }
}