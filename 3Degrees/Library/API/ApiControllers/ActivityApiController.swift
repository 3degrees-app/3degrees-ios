//
//  ActivityApiController.swift
//  3Degrees
//
//  Created by Gigster Developer on 8/13/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation
import ThreeDegreesClient

protocol ActivityApiProtocol: BaseApiProtocol {
    func getActivities(mode: Mode, limit: Int, page: Int,
                       completion:(feedItems:[Activity]?) -> ())
    func markAsSeen(activityItemId: Int, completion:() -> ())

    func getUser(username: String, completion:(User) -> ())

    func acceptConnection(username: String, completion:() -> ())

    func declineConnection(username: String, completion:() -> ())
}

struct ActivityApiController: ActivityApiProtocol {
    var api: ApiProtocol = ApiController()

    func getActivities(mode: Mode,
                       limit: Int,
                       page: Int,
                       completion: (feedItems: [Activity]?) -> ()) {
        showActivityIndicator()
        api.getActivities(mode, limit: limit, page: page) { (data, error, headers) in
            guard self.handleError(error, getErrorMessage: self.getErrorMessage)
                else { return }
            completion(feedItems: data)
            self.hideActivityIndicator()
        }
    }

    func markAsSeen(activityItemId: Int, completion: () -> ()) {
        api.markActivityItemAsSeen(activityItemId) { (data, error, headers) in
            guard self.handleError(error, getErrorMessage: self.getErrorMessage)
                else { return }
            completion()
        }
    }

    func getUser(username: String, completion:(User) -> ()) {
        showActivityIndicator()
        api.getUser(username) { (user, error, headers) in
            guard self.handleError(error, getErrorMessage: self.getErrorMessage)
                else { return }
            guard let user = user else {
                self.showUndefinedServerError()
                return
            }
            completion(user)
            self.hideActivityIndicator()
        }
    }

    func acceptConnection(username: String, completion:() -> ()) {
        showActivityIndicator()
        api.acceptConnectionInvite(username) { (data, error, headers) in
            guard self.handleError(error, getErrorMessage: self.getErrorMessage)
                else { return }
            completion()
            self.hideActivityIndicator()
        }
    }

    func declineConnection(username: String, completion:() -> ()) {
        showActivityIndicator()
        api.declineConnectionInvite(username) { (data, error, headers) in
            guard self.handleError(error, getErrorMessage: self.getErrorMessage)
                else { return }
            completion()
            self.hideActivityIndicator()
        }
    }

    func getErrorMessage(error: ErrorType?) -> String? {
        if let e = error {
            switch e {
            case ErrorResponse.activityGet403(let e):
                AppController.shared.logOut()
                return e.message
            case ErrorResponse.activityIdPut403(let e):
                AppController.shared.logOut()
                return e.message
            case ErrorResponse.activityIdPut404(let e): return e.message
            case ErrorResponse.usersUsernameGet404(let e): return e.message
            case ErrorResponse.connectionsUsernamePut403(let e):
                AppController.shared.logOut()
                return e.message
            case ErrorResponse.connectionsUsernamePut404(let e): return e.message
            case ErrorResponse.connectionsUsernameDelete403(let e):
                AppController.shared.logOut()
                return e.message
            default: return ""
            }
        }
        return nil
    }
}
