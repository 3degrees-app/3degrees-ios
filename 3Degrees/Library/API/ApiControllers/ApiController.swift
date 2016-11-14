//
//  NetworkController.swift
//  3Degrees
//
//  This class wraps static DefaultAPI class into non-static object
//  to let test buisness logic dependent on it.
//
//  Created by Gigster Developer on 4/27/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation
import Bond
import ThreeDegreesClient


protocol ApiProtocol {
    // Authentication

    func login(loginForm: LoginForm,
               loginType: DefaultAPI.LoginType_authLoginTypePut,

               completion:(
                    key: SessionKey?,
                    error: ErrorType?,
                    headers: Dictionary<NSObject, AnyObject>) -> ())
    func signUp(userForm: UserForm,
                completion:(
                    key: SessionKey?,
                    error: ErrorType?,
                    headers: Dictionary<NSObject, AnyObject>) -> ())
    func forgotPassword(email: String,
                        completion: (
                            data: Empty?,
                            error: ErrorType?,
                            headers: Dictionary<NSObject, AnyObject>) -> ())
    func resetPass(password: String,
                   completion: (
                        data: SessionKey?,
                        error: ErrorType?,
                        headers: Dictionary<NSObject, AnyObject>) -> ())
    func logout(completion: (
                    data: Empty?,
                    error: ErrorType?,
                    headers: Dictionary<NSObject, AnyObject>) -> ())

    func supportedVersion(version: String,
                          completion: (
                              data: Empty?,
                              error: ErrorType?,
                              headers: Dictionary<NSObject, AnyObject>) -> ())

    // Left Menu

    func staticContent(contentType: String,
                       completion: (
                            content: Content?,
                            error: ErrorType?,
                            headers: Dictionary<NSObject, AnyObject>) -> ())

    // User

    func currentUser(completion: (
                        user: PrivateUser?,
                        error: ErrorType?,
                        headers: Dictionary<NSObject, AnyObject>) -> ())

    func toggleIsSingle(toggleValue: Bool,
                        completion:(
                            data: Empty?,
                            error: ErrorType?,
                            headers: Dictionary<NSObject, AnyObject>) -> ())
    func updateCurrentUser(user: UserForm,
                           completion:(
                                data: Empty?,
                                error:ErrorType?,
                                headers: Dictionary<NSObject, AnyObject>) -> ())

    func matchWith(gender: DefaultAPI.Gender_meMatchWithGenderPut,
                   completion: (data: Empty?,
                                error: ErrorType?,
                                headers: Dictionary<NSObject, AnyObject>) -> ())

    func uploadImage(image: NSData,
                     completion:(
                        data: Image?,
                        error: ErrorType?,
                        headers: Dictionary<NSObject, AnyObject>) -> ())

    func switchPushNotifications(
        deviceToken: String?,
        value: Bool,
        completion:(data: Empty?,
                    error: ErrorType?,
                    headers: Dictionary<NSObject, AnyObject>) -> ()
    )

    func pushNotificationsValue(completion:(data: Empty?,
                                            error: ErrorType?,
                                            headers: Dictionary<NSObject, AnyObject>) -> ())

    // My network

    func getSingles(page: Int,
                    limit: Int,
                    completion: (
                        users:[User]?,
                        error:ErrorType?,
                        headers: Dictionary<NSObject, AnyObject>) -> ())
    func getMatchmakers(page: Int,
                        limit: Int,
                        completion: (
                            users:[User]?,
                            error:ErrorType?,
                            headers: Dictionary<NSObject, AnyObject>) -> ())
    func getDates(page: Int,
                  limit: Int,
                  completion: (
                    users:[User]?,
                    error:ErrorType?,
                    headers: Dictionary<NSObject, AnyObject>) -> ())
    func deleteConnection(username: String,
                          completion: (
                            data:Empty?,
                            error:ErrorType?,
                            headers: Dictionary<NSObject, AnyObject>) -> ())
    func getUsers(requestModel: UsersRequestModel,
                  completion: ((
                        data: [User]?,
                        error: ErrorType?,
                        headers: Dictionary<NSObject, AnyObject>) -> Void))
    func addUserToMyNetwork(username: String,
                            completion:(
                                data:Empty?,
                                error:ErrorType?,
                                headers: Dictionary<NSObject, AnyObject>) -> ())
    func sendMessage(username: String,
                     message: MessageForm,
                     completion: (
                        data:Empty?,
                        error:ErrorType?,
                        headers: Dictionary<NSObject, AnyObject>) -> ())
    func sendImage(username: String,
                   image: NSData,
                   completion: (
                        data: Image?,
                        error: ErrorType?,
                        headers: Dictionary<NSObject, AnyObject>) -> ())
    func getMessages(username: String,
                     limit: Int,
                     page: Int,
                     completion: (
                        messages:[Message]?,
                        error:ErrorType?,
                        headers: Dictionary<NSObject, AnyObject>) -> ())

    // Activity Feed

    func getActivities(mode: Mode,
                       limit: Int,
                       page: Int,
                       completion: (
                            data: [Activity]?,
                            error: ErrorType?,
                            headers: Dictionary<NSObject, AnyObject>) -> ())

    func markActivityItemAsSeen(id: Int,
                                completion: (
                                    data: Empty?,
                                    error: ErrorType?,
                                    headers: Dictionary<NSObject, AnyObject>) -> ())

    func getUser(username: String,
                 completion: (
                    user: User?,
                    error: ErrorType?,
                    headers: Dictionary<NSObject, AnyObject>) ->())

    func acceptConnectionInvite(username: String,
                                completion: (
                                    data: Empty?,
                                    error: ErrorType?,
                                    headers: Dictionary<NSObject, AnyObject>) -> ())

    func declineConnectionInvite(username: String,
                                 completion: (
                                    data: Empty?,
                                    error: ErrorType?,
                                    headers: Dictionary<NSObject, AnyObject>) -> ())


    // Pair Up

    func getMySinglesForPairUp(page: Int,
                               limit: Int,
                               completion: (data: [User]?,
                                            error: ErrorType?,
                                            headers: Dictionary<NSObject, AnyObject>) -> ())

    func getPotentialMatches(username: String,
                             page: Int,
                             limit: Int,
                             ageFrom: Int?,
                             ageTo: Int?,
                             matchmakerUsername: String?,
                             gender: DefaultAPI.Gender_usersUsernamePotentialMatchesGet?,
                             completion: (data: [User]?,
                                          error: ErrorType?,
                                          headers: Dictionary<NSObject, AnyObject>) -> ())

    func pairUp(username: String,
                matchUsername: String,
                completion:(data: Empty?,
                            error: ErrorType?,
                            headers: Dictionary<NSObject, AnyObject>) -> ())

    func markMatchAsViewed(username: String,
                           matchUsername: String,
                           completion: (data: Empty?,
                                        error: ErrorType?,
                                        headers: Dictionary<NSObject, AnyObject>) -> ())

    // Dateproposal

    func getDatesProposals(limit: Int,
                           page: Int,
                           completion: (data: [User]?,
                                        error: ErrorType?,
                                        headers: Dictionary<NSObject, AnyObject>) -> ())
    func acceptDate(username: String,
                    completion: (data: Status?,
                                 error: ErrorType?,
                                 headers: Dictionary<NSObject, AnyObject>) -> ())
    func declineDate(username: String,
                     completion: (data: Empty?,
                                  error: ErrorType?,
                                  headers: Dictionary<NSObject, AnyObject>) -> ())
    func suggestDates(username: String,
                      dates: [NSDate],
                      completion: (data: Empty?,
                                   error: ErrorType?,
                                   headers: Dictionary<NSObject, AnyObject>) -> ())
    func acceptSuggestedDate(username: String,
                             date: NSDate,
                             completion: (data: Empty?,
                                          error: ErrorType?,
                                          headers: Dictionary<NSObject, AnyObject>) -> ())

    func getSuggestedTimes(username: String,
                           completion: (data: Dates?,
                                        error: ErrorType?,
                                        headers: Dictionary<NSObject, AnyObject>) -> ())
}

struct ApiController: ApiProtocol {
    typealias SignUpCompletionHandler  = ((
        key: SessionKey?,
        error: ErrorType?,
        headers: Dictionary<NSObject, AnyObject>) -> ())
    typealias SignInCompletionHandler  = ((
        key: SessionKey?,
        error: ErrorType?,
        headers: Dictionary<NSObject, AnyObject>) -> ())
    typealias OtherAuthCompletionHandler = ((
        data: Empty?,
        error: ErrorType?,
        headers: Dictionary<NSObject, AnyObject>) -> ())

    init() {
        guard let token = AppController.shared.cacheController.getAuthToken() else { return }
        ThreeDegreesClientAPI.customHeaders.updateValue(
            token,
            forKey: Constants.Api.SessionKeyHeader)
    }

    func login(loginForm: LoginForm, loginType: DefaultAPI.LoginType_authLoginTypePut,
               completion:SignInCompletionHandler) {
        DefaultAPI.authLoginTypePut(loginType: loginType, loginForm: loginForm, completion: completion)
    }

    func signUp(userForm: UserForm, completion:SignUpCompletionHandler) {
        DefaultAPI.usersPut(userForm: userForm, completion: completion)
    }

    func forgotPassword(email: String, completion: OtherAuthCompletionHandler) {
        DefaultAPI.authForgotPasswordEmailAddressPut(emailAddress: email, completion: completion)
    }

    func resetPass(password: String,
                   completion: (
                        data: SessionKey?,
                        error: ErrorType?,
                        headers: Dictionary<NSObject, AnyObject>) -> ()) {
        let passwordForm = PasswordForm()
        passwordForm.password = password
        DefaultAPI.mePasswordPut(passwordForm: passwordForm, completion: completion)
    }

    func logout(completion: OtherAuthCompletionHandler) {
        DefaultAPI.authDelete(completion)
    }

    func supportedVersion(
        version: String,
        completion: (data: Empty?,
                     error: ErrorType?,
                     headers: Dictionary<NSObject, AnyObject>) -> ()) {
        DefaultAPI.supportedVersionsVersionGet(version: version,
                                               completion: completion)
    }

    func staticContent(
        contentType: String,
        completion: (content: Content?,
                     error: ErrorType?,
                     headers: Dictionary<NSObject, AnyObject>) -> ()) {
        DefaultAPI.contentContentTypeGet(contentType: contentType,
                                         completion: completion)
    }

    func currentUser(completion:(
                        user: PrivateUser?,
                        error: ErrorType?,
                        headers: Dictionary<NSObject, AnyObject>) -> ()) {
        DefaultAPI.meGet(completion)
    }

    func toggleIsSingle(toggleValue: Bool,
                        completion:(
                            data: Empty?,
                            error: ErrorType?,
                            headers: Dictionary<NSObject, AnyObject>) -> ()) {
        if toggleValue {
            DefaultAPI.meIsSinglePut(completion)
        } else {
            DefaultAPI.meIsSingleDelete(completion)
        }
    }

    func updateCurrentUser(userForm: UserForm,
                           completion:(
                                data: Empty?,
                                error: ErrorType?,
                                headers: Dictionary<NSObject, AnyObject>) -> ()) {
        DefaultAPI.mePut(user: userForm, completion: completion)
    }

    func matchWith(gender: DefaultAPI.Gender_meMatchWithGenderPut,
                   completion: (data: Empty?,
        error: ErrorType?,
        headers: Dictionary<NSObject, AnyObject>) -> ()) {
        DefaultAPI.meMatchWithGenderPut(gender: gender, completion: completion)
    }

    func uploadImage(image: NSData,
                     completion:(
                        data: Image?,
                        error: ErrorType?,
                        headers: Dictionary<NSObject, AnyObject>) -> ()) {
        let fileUpload = FileUpload(body: image,
                                    fileName: "\(NSDate().timeIntervalSince1970)",
                                    mimeType: "image/jpeg")
        DefaultAPI.meImagePost(image: fileUpload, completion: completion)
    }

    func switchPushNotifications(deviceToken: String?,
                                 value: Bool,
                                 completion:(data: Empty?,
                                             error: ErrorType?,
                                             headers: Dictionary<NSObject, AnyObject>) -> ()) {
        if value {
            let metadata = SubscriptionMetadata()
            metadata.deviceToken = deviceToken
            DefaultAPI.subscriptionsTypePut(
                type: DefaultAPI.ModelType_subscriptionsTypePut.IosPush,
                metadata: metadata,
                completion: completion)
        } else {
            DefaultAPI.subscriptionsTypeDelete(
                type: DefaultAPI.ModelType_subscriptionsTypeDelete.IosPush,
                completion: completion)
        }
    }

    func pushNotificationsValue(
        completion:(data: Empty?,
                    error: ErrorType?,
                    headers: Dictionary<NSObject, AnyObject>) -> ()) {
        DefaultAPI.subscriptionsTypeGet(
            type: DefaultAPI.ModelType_subscriptionsTypeGet.IosPush,
            completion: completion)
    }


    func getSingles(page: Int,
                    limit: Int,
                    completion: (
                        users: [User]?,
                        error:ErrorType?,
                        headers: Dictionary<NSObject, AnyObject>) -> ()) {
        DefaultAPI.singlesGet(page: Int32(page), limit: Int32(limit), completion: completion)
    }

    func getMatchmakers(page: Int,
                        limit: Int,
                        completion: (
                            users:[User]?,
                            error:ErrorType?,
                            headers: Dictionary<NSObject, AnyObject>) -> ()) {
        DefaultAPI.matchmakersGet(page: Int32(page), limit: Int32(limit), completion: completion)
    }

    func getDates(page: Int,
                  limit: Int,
                  completion: (
                    users:[User]?,
                    error:ErrorType?,
                    headers: Dictionary<NSObject, AnyObject>) -> ()) {
        DefaultAPI.matchesGet(matchType: .Accepted, page: Int32(page), limit: Int32(limit), completion: completion)
    }

    func deleteConnection(username: String,
                          completion: (
                                data:Empty?,
                                error:ErrorType?,
                                headers: Dictionary<NSObject, AnyObject>) -> ()) {
        DefaultAPI.connectionsUsernameDelete(username: username, completion: completion)
    }

    func getUsers(requestModel: UsersRequestModel,
                  completion: (
                        (data: [User]?,
                         error: ErrorType?,
                         headers: Dictionary<NSObject, AnyObject>) -> Void)) {
        DefaultAPI.usersGet(matchmaker: requestModel.matchmaker,
                            query: requestModel.query,
                            singlesOnly: requestModel.singlesOnly,
                            excludeMyConnections: requestModel.excludeMyConnections,
                            limit: Int32(requestModel.limit),
                            page: Int32(requestModel.page),
                            completion: completion)
    }

    func addUserToMyNetwork(username: String,
                            completion:(
                                data: Empty?,
                                error:ErrorType?,
                                headers: Dictionary<NSObject, AnyObject>) -> ()) {
        DefaultAPI.usersUsernameConnectionsPut(username: username, completion: completion)
    }

    func getMessages(username: String,
                     limit: Int,
                     page: Int,
                     completion: (
                        messages:[Message]?,
                        error:ErrorType?,
                        headers: Dictionary<NSObject, AnyObject>) -> ()) {
        DefaultAPI.messagesUsernameGet(username: username,
                                       limit: Int32(limit), page: Int32(page), completion: completion)
    }

    func sendMessage(username: String,
                     message: MessageForm,
                     completion: (
                        data:Empty?,
                        error:ErrorType?,
                        headers: Dictionary<NSObject, AnyObject>) -> ()) {
        DefaultAPI.messagesUsernamePut(username: username, message: message, completion: completion)
    }

    func sendImage(username: String,
                   image: NSData,
                   completion: (
                        data: Image?,
                        error: ErrorType?,
                        headers: Dictionary<NSObject, AnyObject>) -> ()) {
        let fileUpload = FileUpload(body: image,
                                    fileName: "\(NSDate().timeIntervalSince1970)",
                                    mimeType: "image/jpeg")
        DefaultAPI.messagesUsernameImagePost(username: username,
                                             image: fileUpload,
                                             completion: completion)
    }

    func getActivities(mode: Mode,
                       limit: Int,
                       page: Int,
                       completion: (
                            data: [Activity]?,
                            error: ErrorType?,
                            headers: Dictionary<NSObject, AnyObject>) -> ()) {
        var apiMode: DefaultAPI.AppMode_activityGet?
        switch mode {
        case .Matchmaker:
            apiMode = DefaultAPI.AppMode_activityGet.Matchmaker
        default:
            apiMode = DefaultAPI.AppMode_activityGet.Single
        }
        DefaultAPI.activityGet(appMode: apiMode,
                               limit: Int32(limit),
                               page: Int32(page),
                               completion: completion)
    }

    func markActivityItemAsSeen(id: Int,
                                completion: (
                                    data: Empty?,
                                    error: ErrorType?,
                                    headers: Dictionary<NSObject, AnyObject>) -> ()) {
        DefaultAPI.activityIdPut(id: Int32(id), completion: completion)
    }

    func getUser(username: String,
                 completion: (
        user: User?,
        error: ErrorType?,
        headers: Dictionary<NSObject, AnyObject>) ->()) {
        DefaultAPI.usersUsernameGet(username: username, completion: completion)
    }

    func acceptConnectionInvite(username: String,
                                completion: (
                                    data: Empty?,
                                    error: ErrorType?,
                                    headers: Dictionary<NSObject, AnyObject>) -> ()) {
        DefaultAPI.connectionsUsernamePut(username: username, completion: completion)
    }

    func declineConnectionInvite(username: String,
                                 completion: (
                                    data: Empty?,
                                    error: ErrorType?,
                                    headers: Dictionary<NSObject, AnyObject>) -> ()) {
        DefaultAPI.connectionsUsernameDelete(username: username, completion: completion)
    }

    func getMySinglesForPairUp(page: Int,
                               limit: Int,
                               completion: (data: [User]?,
                                            error: ErrorType?,
                                            headers: Dictionary<NSObject, AnyObject>) -> ()) {
        DefaultAPI.singlesGet(limit: Int32(limit), page: Int32(page), completion: completion)
    }

    func getPotentialMatches(username: String,
                             page: Int,
                             limit: Int,
                             ageFrom: Int?,
                             ageTo: Int?,
                             matchmakerUsername: String?,
                             gender: DefaultAPI.Gender_usersUsernamePotentialMatchesGet?,
                             completion: (data: [User]?,
                                          error: ErrorType?,
                                          headers: Dictionary<NSObject, AnyObject>) -> ()) {
        var ageToInt32: Int32? = nil
        var ageFromInt32: Int32? = nil
        if let ageFrom = ageFrom {
            ageFromInt32 = Int32(ageFrom)
        }
        if let ageTo = ageTo {
            ageToInt32 = Int32(ageTo)
        }
        DefaultAPI.usersUsernamePotentialMatchesGet(username: username,
                                                    ageFrom: ageFromInt32,
                                                    ageTo: ageToInt32,
                                                    gender: gender,
                                                    matchmaker: matchmakerUsername,
                                                    limit: Int32(limit),
                                                    page: Int32(page),
                                                    completion: completion)
    }

    func pairUp(username: String,
                matchUsername: String,
                completion:(data: Empty?,
                            error: ErrorType?,
                            headers: Dictionary<NSObject, AnyObject>) -> ()) {
        let matchUsernameObject = UserName()
        matchUsernameObject.username = matchUsername
        DefaultAPI.singlesUsernamePut(username: username,
                                      matchUsername: matchUsernameObject,
                                      completion: completion)
    }

    func markMatchAsViewed(username: String,
                           matchUsername: String,
                           completion: (data: Empty?,
                                        error: ErrorType?,
                                        headers: Dictionary<NSObject, AnyObject>) -> ()) {
        let matchmakerUsernameObject = UserName()
        matchmakerUsernameObject.username = matchUsername
        DefaultAPI.singlesUsernamePatch(username: username,
                                        matchUsername: matchmakerUsernameObject,
                                        completion: completion)
    }

    func getDatesProposals(limit: Int,
                           page: Int,
                           completion: (data: [User]?,
                                        error: ErrorType?,
                                        headers: Dictionary<NSObject, AnyObject>) -> ()) {
        DefaultAPI.matchesGet(matchType: .Pending, limit: Int32(limit), page: Int32(page), completion: completion)
    }

    func acceptDate(username: String,
                    completion: (data: Status?,
                                 error: ErrorType?,
                                 headers: Dictionary<NSObject, AnyObject>) -> ()) {
        DefaultAPI.matchesUsernamePut(username: username, completion: completion)
    }

    func declineDate(username: String,
                     completion: (data: Empty?,
                                  error: ErrorType?,
                                  headers: Dictionary<NSObject, AnyObject>) -> ()) {
        DefaultAPI.matchesUsernameDelete(username: username, completion: completion)
    }

    func suggestDates(username: String,
                      dates: [NSDate],
                      completion: (data: Empty?,
                                   error: ErrorType?,
                                   headers: Dictionary<NSObject, AnyObject>) -> ()) {
        let datesObject = Dates()
        datesObject.dates = dates
        DefaultAPI.matchesUsernameDatesPut(username: username, dates: datesObject, completion: completion)
    }

    func acceptSuggestedDate(username: String,
                             date: NSDate,
                             completion: (data: Empty?,
                                          error: ErrorType?,
                                          headers: Dictionary<NSObject, AnyObject>) -> ()) {
        DefaultAPI.matchesUsernameDatesDatePut(username: username, date: date, completion: completion)
    }

    func getSuggestedTimes(username: String,
                           completion: (data: Dates?,
                                        error: ErrorType?,
                                        headers: Dictionary<NSObject, AnyObject>) -> ()) {
        DefaultAPI.matchesUsernameDatesGet(username: username,
                                           completion: completion)
    }
}
