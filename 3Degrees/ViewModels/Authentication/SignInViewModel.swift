//
//  SignInViewModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 4/28/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import SVProgressHUD
import LKAlertController
import Router
import Rswift

extension SignInViewModel: SignInViewControllerProtocol {
    func signIn() {
        guard let e = email, pass = password where !e.isEmpty && !pass.isEmpty else {
            showEmptyEmailOrPasswordError()
            return
        }

        apiController.loginWithEmail(e, password: pass, completion: loginCompleted)
    }

    func showEmptyEmailOrPasswordError() {
        SVProgressHUD.showErrorWithStatus(R.string.localizable.emptyEmailOrPassError())
    }
}

extension SignInViewModel: FacebookLoginDelegate {
    func handleSuccessLogin(token: String) {
        guard !token.isEmpty else {
            showAlertWithUndefinedError()
            return
        }
        apiController.loginWithFacebook(token, completion: loginCompleted)
    }

    func handleError(error: FacebookLoginError) {
        if case .Cancelled = error { return }
        showAlertWithUndefinedError()
    }
}

class SignInViewModel: FullScreenViewModelProtocol, Routable {
    let router = Router()
    var appNavigator: AppNavigator?
    var apiController: AuthApiProtocol = AuthApiController()
    lazy var facebookLoginViewModel: FacebookLoginViewModel = {
        return FacebookLoginViewModel(delegate: self)
    }()

    var email: String? = ""
    var password: String? = ""

    init(appNavigator: AppNavigator) {
        self.appNavigator = appNavigator
    }

    var canSignIn: Bool {
        return !(email ?? "").isEmpty && !(password ?? "").isEmpty
    }

    func showForgotPassDialog() {
        let alert = Alert(
            title: R.string.localizable.forgotPassTitle(),
            message: R.string.localizable.forgotPassMessage())
        alert.configureForgotPassAlertController(ForgotPasswordViewModel())
        alert.show(animated: true)
    }

    func backButtonClicked() {
        appNavigator?.popAction()
    }

    func loginCompleted(startPage: String?) {
        guard let startPage = startPage else { route("/select-mode"); return }
        route("\(startPage)")
    }
}
