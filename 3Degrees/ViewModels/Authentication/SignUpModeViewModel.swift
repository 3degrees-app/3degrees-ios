//
//  SignUpViewModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 4/27/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import FBSDKCoreKit
import FBSDKLoginKit
import Foundation
import Bond

extension SignUpModeViewModel: FacebookLoginDelegate {
    func handleSuccessLogin(token: String) {
        guard !token.isEmpty else {
            showAlertWithUndefinedError()
            return
        }
        apiController.signUp(token) {[unowned self] in
            let segueId = R.segue.signUpModeViewController.toModeSelection.identifier
            self.appNavigator?.showAction(identifier: segueId)
        }
    }

    func handleError(error: FacebookLoginError) {
        showAlertWithUndefinedError()
    }
}

extension SignUpModeViewModel: SignUpModeViewControllerDelegate {
    func signUpWithEmail() {
        let seguedId = R.segue.signUpModeViewController.toSignUpWithEmail.identifier
        appNavigator?.showAction(identifier: seguedId)
    }

    func login() {
        let seguedId = R.segue.signUpModeViewController.toLogin.identifier
        appNavigator?.showAction(identifier: seguedId)
    }
}

class SignUpModeViewModel: NSObject, ViewModelProtocol {
    var appNavigator: AppNavigator?
    var apiController: AuthApiProtocol = AuthApiController()
    lazy var facebookLoginViewModel: FacebookLoginViewModel = {
        return FacebookLoginViewModel(delegate: self)
    }()

    init(appNavigator: AppNavigator) {
        self.appNavigator = appNavigator
    }
}
