//
//  DateProposalApiController.swift
//  3Degrees
//
//  Created by Gigster Developer on 8/25/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation
import ThreeDegreesClient

protocol DateProposalApiProtocol: BaseApiProtocol {
    func getDatesProposals(limit: Int, page: Int, completion: ([User]) -> ())
    func acceptDate(username: String, completion: (bothPartiesAccepted: Bool) -> ())
    func declineDate(username: String, completion: () -> ())
    func suggestDates(username: String, dates: [NSDate], completion: () -> ())
    func acceptSuggestedDate(username: String, date: NSDate, completion: () -> ())
    func getSuggestedTimes(username: String, completion: ([NSDate]) -> ())
}

struct DateProposalApiController: DateProposalApiProtocol {
    var api: ApiProtocol = ApiController()

    func getDatesProposals(limit: Int, page: Int, completion: ([User]) -> ()) {
        showActivityIndicator()
        api.getDatesProposals(limit, page: page) { (data, error, headers) in
            guard self.handleError(error, getErrorMessage: self.getDateProposalsErrorMessage) else {
                return
            }
            guard let users = data else { return }
            completion(users)
            self.hideActivityIndicator()
        }
    }

    func acceptDate(username: String, completion: (bothPartiesAccepted: Bool) -> ()) {
        showActivityIndicator()
        api.acceptDate(username) { (data, error, headers) in
            guard self.handleError(error, getErrorMessage: self.acceptDateErrorMessage) else {
                return
            }
            let bothPartiesAccepted = data?.status == .Accepted
            completion(bothPartiesAccepted: bothPartiesAccepted)
            self.hideActivityIndicator()
        }
    }

    func declineDate(username: String, completion: () -> ()) {
        showActivityIndicator()
        api.declineDate(username) { (data, error, headers) in
            guard self.handleError(error, getErrorMessage: self.declineDateErrorMessage) else {
                return
            }
            completion()
            self.hideActivityIndicator()
        }
    }

    func suggestDates(username: String, dates: [NSDate], completion: () -> ()) {
        showActivityIndicator()
        api.suggestDates(username, dates: dates) { (data, error, headers) in
            guard self.handleError(error, getErrorMessage: self.suggestDatesErrorMessage) else {
                return
            }
            completion()
            self.hideActivityIndicator()
        }
    }

    func acceptSuggestedDate(username: String, date: NSDate, completion: () -> ()) {
        showActivityIndicator()
        api.acceptDate(username) { (data, error, headers) in
            guard self.handleError(error, getErrorMessage: self.acceptSuggestedDateErrorMessage) else {
                return
            }
            completion()
            self.hideActivityIndicator()
        }
    }

    func getSuggestedTimes(username: String, completion: ([NSDate]) -> ()) {
        showActivityIndicator()
        api.getSuggestedTimes(username) { (data, error, headers) in
            guard self.handleError(error,
                                   getErrorMessage: self.getSuggestedTimesErrorMessage)
                else { return }
            completion(data?.dates ?? [])
            self.hideActivityIndicator()
        }
    }

    func getDateProposalsErrorMessage(error: ErrorType?) -> String? {
        if let e = error as? ErrorResponse {
            switch e {
            case ErrorResponse.matchesGet403(let e): return e.message
            default:
                return ""
            }
        }
        return nil
    }

    func acceptDateErrorMessage(error: ErrorType?) -> String? {
        if let e = error as? ErrorResponse {
            switch e {
            case ErrorResponse.matchesUsernamePut202(_): return nil
            case ErrorResponse.matchesUsernamePut403(let e):
                AppController.shared.logOut()
                return e.message
            case ErrorResponse.matchesUsernamePut404(let e): return e.message
            case ErrorResponse.RawError(let code, let data, let err):
                guard let d = data else { return "" }
                let msg = "\(code)/r/n\(NSString(data: d, encoding: NSUTF8StringEncoding))/r/n \(err))"
                print(msg)
                return msg
            default:
                return ""
            }
        }
        return nil
    }

    func declineDateErrorMessage(error: ErrorType?) -> String? {
        if let e = error as? ErrorResponse {
            switch e {
            case ErrorResponse.matchesUsernameDelete403(let e):
                AppController.shared.logOut()
                return e.message
            default:
                return ""
            }
        }
        return nil
    }

    func suggestDatesErrorMessage(error: ErrorType?) -> String? {
        if let e = error as? ErrorResponse {
            switch e {
            case ErrorResponse.matchesUsernameDatesPut403(let e):
                AppController.shared.logOut()
                return e.message
            case ErrorResponse.matchesUsernameDatesPut404(let e): return e.message
            default:
                return ""
            }
        }
        return nil
    }

    func acceptSuggestedDateErrorMessage(error: ErrorType?) -> String? {
        if let e = error as? ErrorResponse {
            switch e {
            case ErrorResponse.matchesUsernameDatesDatePut403(let e):
                AppController.shared.logOut()
                return e.message
            case ErrorResponse.matchesUsernameDatesDatePut404(let e): return e.message
            default:
                return ""
            }
        }
        return nil
    }

    func getSuggestedTimesErrorMessage(error: ErrorType?) -> String? {
        if let e = error as? ErrorResponse {
            switch e {
            case ErrorResponse.matchesUsernameDatesGet403(let e):
                AppController.shared.logOut()
                return e.message
            case ErrorResponse.matchesUsernameDatesGet404(let e): return e.message
            default:
                return ""
            }
        }
        return nil
    }
}
