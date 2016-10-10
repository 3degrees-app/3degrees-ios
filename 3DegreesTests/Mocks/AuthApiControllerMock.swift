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
        completion: () -> ()) {
        if shouldError {
            return
        } else {
            completion()
        }
    }
    
    func loginWithEmail(
        email: String,
        password: String,
        completion: () -> ()) {
        if shouldError {
            return
        } else {
            completion()
        }
    }

    func signUp(
        facebookAccessToken: String?,
        completion: () -> ()) {
        if shouldError {
            return
        } else {
            completion()
        }
    }

    func signUp(user: PrivateUser,
                completion: () -> ()) {
        if shouldError {
            return
        } else {
            completion()
        }
    }

    func forgotPassword(email: String, completion: (() -> ())?) {
        if shouldError {
            return
        } else {
            completion?()
        }
    }

    func logout(completion: (()->())?) {
        if shouldError {
            return
        } else {
            completion?()
        }
    }

    func resetPassword(password: String, completion: () -> ()) {
        if shouldError {
            return
        } else {
            completion()
        }
    }
}
