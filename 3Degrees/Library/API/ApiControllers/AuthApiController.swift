//
//  AuthApiController.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/31/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation
import LKAlertController
import ThreeDegreesClient

protocol AuthApiProtocol: BaseApiProtocol {
    func loginWithEmail(email: String, password: String, completion: () -> ())
    func loginWithFacebook(fbAccessToken: String, completion: () -> ())
    func signUp(facebookAccessToken: String?, completion:() -> ())
    func signUp(user: PrivateUser, completion: () -> ())
    func forgotPassword(email: String, completion: (() -> ())?)
    func resetPassword(password: String, completion: () -> ())
    func logout(completion: (() -> ())?)
}

struct AuthApiController: AuthApiProtocol {
    var api: ApiProtocol = ApiController()
    var cache: CacheProtocol = AppController.shared.cacheController

    typealias AuthCompletionHandler = (() -> ())

    func loginWithEmail(email: String, password: String, completion:AuthCompletionHandler) {
        showActivityIndicator()
        let loginForm = LoginForm()
        let loginFormEmail = LoginFormEmail()
        loginFormEmail.emailAddress = email
        loginFormEmail.password = password
        loginForm.email = loginFormEmail
        let loginType = DefaultAPI.LoginType_authLoginTypePut.Email
        api.login(loginForm, loginType: loginType) {(key, error, headers) in
            self.authenticationCompleted(key,
                                         error: error,
                                         completion: completion)
        }
    }

    func loginWithFacebook(fbAccessToken: String, completion:AuthCompletionHandler) {
        showActivityIndicator()
        let loginForm = LoginForm()
        let loginFormFacebook = LoginFormFacebook()
        loginFormFacebook.accessToken = fbAccessToken
        loginForm.facebook = loginFormFacebook
        let loginType = DefaultAPI.LoginType_authLoginTypePut.Facebook
        api.login(loginForm, loginType: loginType) {(key, error, headers) in
            self.authenticationCompleted(key,
                                         error: error,
                                         completion: completion)
        }
    }

    func signUp(facebookAccessToken: String?, completion:AuthCompletionHandler) {
        showActivityIndicator()
        let userForm = UserForm()
        userForm.fbAccessToken = facebookAccessToken
        api.signUp(userForm) { (key, error, headers) in
            self.authenticationCompleted(
                key, error: error, completion: completion)
        }
    }

    func signUp(user: PrivateUser, completion:AuthCompletionHandler) {
        showActivityIndicator()
        let userForm = UserForm()
        userForm.user = user
        api.signUp(userForm) { (key, error, headers) in
            self.authenticationCompleted(
                key, error: error, completion: completion)
        }
    }

    func forgotPassword(email: String,
                        completion: AuthCompletionHandler?) {
        showActivityIndicator()
        api.forgotPassword(email) { (data, error, headers) in
            guard self.handleError(error, getErrorMessage: self.getErrorMessage) else { return }
            completion?()
        }
    }

    func resetPassword(password: String, completion: AuthCompletionHandler) {
        showActivityIndicator()
        api.resetPass(password) { (data, error, headers) in
            guard self.handleError(error, getErrorMessage: self.getPasswordResetErrorMessage) else { return }
            self.authenticationCompleted(data, error: error, completion: completion)
        }
    }

    func logout(completion: AuthCompletionHandler?) {
        api.logout { (data, error, headers) in
            ThreeDegreesClientAPI.customHeaders.removeAll()
            completion?()
        }
    }

    func authenticationCompleted(sessionKey: SessionKey?,
                                 error: ErrorType?,
                                 completion: AuthCompletionHandler) {
        guard self.handleError(error, getErrorMessage: getErrorMessage) else {
            ThreeDegreesClientAPI.customHeaders.removeValueForKey(Constants.Api.SessionKeyHeader)
            return
        }
        guard let sessionKey = sessionKey else {
            self.showUndefinedServerError()
            return
        }
        AppController.shared.cacheController.loggedIn(sessionKey.key)
        completion()
        guard let key = sessionKey.key else { return }
        ThreeDegreesClientAPI.customHeaders.updateValue(key,
                                                        forKey: Constants.Api.SessionKeyHeader)
        self.hideActivityIndicator()
        UserApiController().currentUser {
            UserApiController().pushNotificationsValue { (value) in
                AppController.shared.cacheController.pushNotificationsSettingChanged(value)
            }
        }
    }

    func getErrorMessage(error: ErrorType?) -> String? {
        if let e = error {
            switch e {
            case ErrorResponse.usersPut400(let e): return e.message
            case ErrorResponse.usersPut403(let e):
                return e.message
            case ErrorResponse.authDelete403(let e): return e.message
            case ErrorResponse.authForgotPasswordEmailAddressPut400(let e): return e.message
            case ErrorResponse.authForgotPasswordEmailAddressPut404(let e): return e.message
            case ErrorResponse.authLoginTypePut403(let e): return e.message
            default:
                return ""
            }
        }
        return nil
    }

    func getPasswordResetErrorMessage(error: ErrorType?) -> String? {
        if let e = error {
            switch e {
            case ErrorResponse.mePasswordPut400(let e): return e.message
            case ErrorResponse.mePasswordPut403(let e):
                return e.message
            default:
                return ""
            }
        }
        return nil
    }
}
