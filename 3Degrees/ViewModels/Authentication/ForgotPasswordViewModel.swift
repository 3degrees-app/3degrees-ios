//
//  ForgotPasswordViewModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/20/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation
import LKAlertController
import Rswift
import SVProgressHUD

struct ForgotPasswordViewModel: ViewModelProtocol {
    var router: RoutingProtocol? = nil
    var apiController: AuthApiProtocol? = AuthApiController()

    func resetPassword(email: String, completion: () -> ()) {
        guard !email.isEmpty else { return }
        apiController?.forgotPassword(email) {
            completion()
            SVProgressHUD.showSuccessWithStatus(
                R.string.localizable.forgotPasswordConfirmation()
            )
        }
    }
}
