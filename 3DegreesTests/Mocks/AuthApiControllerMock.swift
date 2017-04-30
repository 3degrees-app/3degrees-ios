//
//  NetworkControllerMock.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/26/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation
import ThreeDegreesClient

@testable import _Degrees

struct AuthApiControllerMock: AuthApiProtocol {

    var api: ApiProtocol = ApiController()
    var  shouldError: Bool = false
    
    func loginWithFacebook(
        fbAccessToken: String,
        completion: (String?) -> ()) {
        if shouldError {
            return
        } else {
            completion(.None)
        }
    }
    
    func loginWithEmail(
        email: String,
        password: String,
        completion: (String?) -> ()) {
        if shouldError {
            return
        } else {
            completion(.None)
        }
    }

    func signUp(
        facebookAccessToken: String?,
        completion: (String?) -> ()) {
        if shouldError {
            return
        } else {
            completion(.None)
        }
    }

    func signUp(user: PrivateUser,
                completion: (String?) -> ()) {
        if shouldError {
            return
        } else {
            completion(.None)
        }
    }

    func forgotPassword(email: String, completion: ((String?) -> ())?) {
        if shouldError {
            return
        } else {
            completion?(.None)
        }
    }

    func logout(completion: ((String?)->())?) {
        if shouldError {
            return
        } else {
            completion?(.None)
        }
    }

    func resetPassword(password: String, completion: (String?) -> ()) {
        if shouldError {
            return
        } else {
            completion(.None)
        }
    }
}
