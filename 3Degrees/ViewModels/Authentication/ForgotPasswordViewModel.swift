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

struct ForgotPasswordViewModel: FullScreenViewModelProtocol {
    var appNavigator: AppNavigator? = nil
    var apiController: AuthApiProtocol? = AuthApiController()

    func resetPassword(email: String, completion: (String?) -> ()) {
        guard !email.isEmpty else { return }
        apiController?.forgotPassword(email) { _ in
            completion(.None)
            SVProgressHUD.showSuccessWithStatus(
                R.string.localizable.forgotPasswordConfirmation()
            )
        }
    }
}
