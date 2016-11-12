//
//  FacebookDelegate.swift
//  3Degrees
//
//  Created by Gigster Developer on 4/28/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import LKAlertController

enum FacebookLoginError: ErrorType {
    case Cancelled
    case NotAllPermissionsGranted
    case FbError(description: String)
}

protocol FacebookLoginDelegate {
    func handleSuccessLogin(token: String)
    func handleError(error: FacebookLoginError)
}

extension FacebookLoginDelegate where Self: ViewModelProtocol {
    func showAlertWithUndefinedError() {
        Alert(
            title: R.string.localizable.error(),
            message: R.string.localizable.undefinedNetworkError()
            ).showOkay()
    }
}

struct FacebookLoginViewModel: ViewModelProtocol {
    var appNavigator: AppNavigator?
    var delegate: FacebookLoginDelegate?

    init(delegate: FacebookLoginDelegate? = nil, appNavigator: AppNavigator? = nil) {
        self.appNavigator = appNavigator
        self.delegate = delegate
    }

    func loginFrom(viewController: UIViewController) {
        let fbLoginManager = FBSDKLoginManager()

        fbLoginManager.logInWithReadPermissions(
            self.facebookPermissions, fromViewController: viewController, handler: self.handleLoginResult)
    }

    private func handleLoginResult(result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if (error != nil) {
            self.delegate?.handleError(.FbError(description: error.description))
        } else if result.isCancelled {
            self.delegate?.handleError(.Cancelled)
        } else {
            if let grantedPermissions = result.grantedPermissions {
                for permission in self.facebookPermissions {
                    if !grantedPermissions.contains(permission) {
                        self.delegate?.handleError(.NotAllPermissionsGranted)
                        return
                    }
                }
                self.delegate?.handleSuccessLogin(result.token.tokenString)
            }
        }
    }
}

extension FacebookLoginViewModel {
    var facebookPermissions: [String] {
        return ["public_profile", "email", "user_friends"]
    }
}
