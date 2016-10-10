//
//  UserApiController.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/31/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation
import ThreeDegreesClient

protocol UserApiProtocol: BaseApiProtocol {
    func currentUser(completion: () -> ())
    func updateUser(user: PrivateUser, completion: () -> ())
    func uploadImage(imageData: NSData, completion: (imageUrl: String?) -> ())
    func matchWith(gender: PrivateUser.MatchWithGender?, completion: () -> ())
    func switchIsSingle(value: Bool, completion: () -> ())
    func switchPushNotifications(deviceToken: String?,
                                 value: Bool,
                                 completion: () -> ())
    func pushNotificationsValue(completion: (value: Bool) -> ())
}

struct UserApiController: UserApiProtocol {
    var api: ApiProtocol = ApiController()

    func currentUser(completion: () -> ()) {
        showActivityIndicator()
        api.currentUser { (user, error, headers) in
            guard self.handleError(error, getErrorMessage: self.getMeRequestsErrorMessage)
                else { return }
            AppController.shared.currentUser.next(user)
            AppController.shared.currentUserImage.next(user?.image)
            completion()
            self.hideActivityIndicator()
        }
    }

    func updateUser(user: PrivateUser, completion: () -> ()) {
        showActivityIndicator()
        let userForm = UserForm()
        userForm.user = user
        api.updateCurrentUser(userForm) { (data, error, headers) in
            guard self.handleError(error, getErrorMessage: self.getMeRequestsErrorMessage)
                else { return }
            completion()
            self.hideActivityIndicator()
        }
    }

    func uploadImage(imageData: NSData, completion: (imageUrl: String?) -> ()) {
        showActivityIndicator()
        api.uploadImage(imageData) { (data, error, headers) in
            guard self.handleError(error, getErrorMessage: self.getMeRequestsErrorMessage) else {
                return
            }
            self.hideActivityIndicator()
            completion(imageUrl: data?.url)
        }
    }

    func matchWith(gender: PrivateUser.MatchWithGender?, completion: () -> ()) {
        showActivityIndicator()
        var genderForMatching: DefaultAPI.Gender_meMatchWithGenderPut?
        if let gender = gender {
            switch gender {
            case .Female:
                genderForMatching = .Female
            case .Male:
                genderForMatching = .Male
            }
        }
        api.matchWith(genderForMatching!) { (data, error, headers) in
            guard self.handleError(error, getErrorMessage: self.getErrorMessage)
                else { return }
            let user = AppController.shared.currentUser.value
            user?.matchWithGender = gender
            AppController.shared.currentUser.next(user)
            completion()
            self.hideActivityIndicator()
        }
    }

    func switchIsSingle(value: Bool, completion:() -> ()) {
        showActivityIndicator()
        api.toggleIsSingle(value) { (data, error, headers) in
            guard self.handleError(error, getErrorMessage: self.getErrorMessage)
                else { return }
            let user = AppController.shared.currentUser.value
            user?.isSingle = value
            AppController.shared.currentUser.next(user)
            completion()
            self.hideActivityIndicator()
        }
    }

    func switchPushNotifications(deviceToken: String?,
                                 value: Bool,
                                 completion: () -> ()) {
        showActivityIndicator()
        api.switchPushNotifications(deviceToken, value: value) { (data, error, headers) in
            guard self.handleError(error, getErrorMessage: self.getNotificationValueGetErrorMessage)
                else { return }
            completion()
            self.hideActivityIndicator()
        }
    }

    func pushNotificationsValue(completion: (value: Bool) -> ()) {
        showActivityIndicator()
        api.pushNotificationsValue { (data, error, headers) in
            guard self.handleError(error, getErrorMessage: self.getNotificationValueGetErrorMessage)
                else { return }
            var active = true
            subscriptionDisabledIf: if let e = (error as? ErrorResponse) {
                guard case ErrorResponse.subscriptionsTypeGet404(_) = e else { break subscriptionDisabledIf }
                active = false
            }
            completion(value: active)
            self.hideActivityIndicator()
        }
    }

    func getErrorMessage(error: ErrorType?) -> String? {
        if let error = error as? ErrorResponse {
            switch error {
            case ErrorResponse.meMatchWithGenderPut400(let e): return e.message
            case ErrorResponse.meMatchWithGenderPut403(let e):
                AppController.shared.logOut()
                return e.message
            case ErrorResponse.meIsSingleDelete400(let e): return e.message
            case ErrorResponse.meIsSingleDelete403(let e):
                AppController.shared.logOut()
                return e.message
            case ErrorResponse.meIsSinglePut400(let e): return e.message
            case ErrorResponse.meIsSinglePut403(let e):
                AppController.shared.logOut()
                return e.message
            default:
                return ""
            }
        }
        return nil
    }

    func getMeRequestsErrorMessage(error: ErrorType?) -> String? {
        if let error = error as? ErrorResponse {
            switch error {
            case ErrorResponse.meGet400(let e): return e.message
            case ErrorResponse.meGet403(let e):
                AppController.shared.logOut()
                return e.message
            case ErrorResponse.mePut400(let e): return e.message
            case ErrorResponse.mePut403(let e):
                AppController.shared.logOut()
                return e.message
            case ErrorResponse.meImagePost400(let e): return e.message
            case ErrorResponse.meImagePost403(let e):
                AppController.shared.logOut()
                return e.message
            case ErrorResponse.meImagePost413(let e): return e.message
            default: return ""
            }
        }
        return nil
    }

    func getSubscriptionErrorMessage(error: ErrorType?) -> String? {
        if let error = error as? ErrorResponse {
            switch error {
            case ErrorResponse.subscriptionsTypeDelete400(let e): return e.message
            case ErrorResponse.subscriptionsTypeDelete403(let e):
                AppController.shared.logOut()
                return e.message
            case ErrorResponse.subscriptionsTypeDelete404(let e): return e.message
            case ErrorResponse.subscriptionsTypePut400(let e): return e.message
            case ErrorResponse.subscriptionsTypePut403(let e):
                AppController.shared.logOut()
                return e.message
            case ErrorResponse.subscriptionsTypePut404(let e): return e.message
            default:
                return ""
            }
        }
        return nil
    }

    func getSubscriptionGetErrorMessage(error: ErrorType?) -> String? {
        if let error = error as? ErrorResponse {
            switch error {
            case ErrorResponse.subscriptionsTypeGet400(let e): return e.message
            case ErrorResponse.subscriptionsTypeGet403(let e):
                AppController.shared.logOut()
                return e.message
            case ErrorResponse.subscriptionsTypeGet404(let e): return e.message
            default:
                return ""
            }
        }
        return nil
    }

    func getNotificationValueGetErrorMessage(error: ErrorType?) -> String? {
        if let error = error as? ErrorResponse {
            switch error {
            case ErrorResponse.subscriptionsTypeGet400(let e):
                return e.message
            case ErrorResponse.subscriptionsTypeGet403(let e):
                AppController.shared.logOut()
                return e.message
            case ErrorResponse.subscriptionsTypeGet404(_):
                return nil
            default:
                return ""
            }
        }
        return nil
    }
}
