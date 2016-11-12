//
//  ResetPasswordViewModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 9/7/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation

struct ResetPasswordViewModel: ViewModelProtocol {
    var appNavigator: AppNavigator? = nil
    var api: AuthApiProtocol = AuthApiController()

    func resetPassword(password: String, completion: () -> ()) {
        api.resetPassword(password) {
            completion()
        }
    }
}
