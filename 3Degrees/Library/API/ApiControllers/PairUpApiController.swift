//
//  PairUpApiController.swift
//  3Degrees
//
//  Created by Gigster Developer on 8/13/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation
import ThreeDegreesClient

protocol PairUpApiProtocol: BaseApiProtocol {
    func getSingles(page: Int, limit: Int, completion:([User]) -> ())
    func getPotentialMatches(request: PotentialMatchesRequestModel)
    func pairUp(username: String, matchUsername: String, completion:() -> ())
    func markMatchAsViewed(username: String, matchUsername: String, completion:() -> ())
}

struct PairUpApiController: PairUpApiProtocol {
    var api: ApiProtocol = ApiController()


    func getSingles(page: Int, limit: Int, completion:([User]) -> ()) {
        api.getMySinglesForPairUp(page, limit: limit) { (data, error, headers) in
            guard self.handleError(error, getErrorMessage: self.getSinglesErrorMessage)
                else { return }
            guard let users = data else { return }
            completion(users)
        }
    }

    func getPotentialMatches(request: PotentialMatchesRequestModel) {
        var gender: DefaultAPI.Gender_usersUsernamePotentialMatchesGet? = nil
        if let requestGender = request.gender {
            switch requestGender {
            case .Male:
                gender = .Male
                break
            case .Female:
                gender = .Female
                break
            default:
                gender = nil
            }
        }
        api.getPotentialMatches(request.username,
                                page: request.page,
                                limit: request.limit,
                                ageFrom: request.ageFrom,
                                ageTo: request.ageTo,
                                matchmakerUsername: request.matchmakerUsername,
                                gender: gender) { (data, error, headers) in
            guard self.handleError(error, getErrorMessage: self.getMatchesErrorMessage)
                else { return }
            guard let users = data else { return }
            request.completion?(users)
        }
    }

    func pairUp(username: String, matchUsername: String, completion:() -> ()) {
        showActivityIndicator()
        api.pairUp(username, matchUsername: matchUsername) { (data, error, headers) in
            guard self.handleError(error, getErrorMessage: self.getPairUpErrorMessage)
                else { return }
            completion()
            self.hideActivityIndicator()
        }
    }

    func markMatchAsViewed(username: String, matchUsername: String, completion:() -> ()) {
        api.markMatchAsViewed(username, matchUsername: matchUsername) { (data, error, headers) in
            guard self.handleError(error, getErrorMessage: self.getMarkAsSeenErrorMessage)
                else { return }
            completion()
        }
    }

    func getSinglesErrorMessage(error: ErrorType?) -> String? {
        if let e = error {
            switch e {
            case ErrorResponse.singlesGet403(let e):
                AppController.shared.logOut()
                return e.message
            default: return ""
            }
        }
        return nil
    }

    func getMatchesErrorMessage(error: ErrorType?) -> String? {
        if let e = error {
            switch e {
            case ErrorResponse.usersUsernamePotentialMatchesGet403(let e):
                AppController.shared.logOut()
                return e.message
            case ErrorResponse.usersUsernamePotentialMatchesGet404(let e): return e.message
            default: return ""
            }
        }
        return nil
    }

    func getPairUpErrorMessage(error: ErrorType?) -> String? {
        if let e = error {
            switch e {
            case ErrorResponse.singlesUsernamePut400(let e): return e.message
            case ErrorResponse.singlesUsernamePut403(let e):
                AppController.shared.logOut()
                return e.message
            case ErrorResponse.singlesUsernamePut404(let e): return e.message
            default: return ""
            }
        }
        return nil
    }

    func getMarkAsSeenErrorMessage(error: ErrorType?) -> String? {
        if let e = error {
            switch e {
            case ErrorResponse.singlesUsernamePatch400(let e): return e.message
            case ErrorResponse.singlesUsernamePatch403(let e):
                AppController.shared.logOut()
                return e.message
            case ErrorResponse.singlesUsernamePatch404(let e): return e.message
            default: return ""
            }
        }
        return nil
    }
}
