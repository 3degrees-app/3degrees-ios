//
//  BaseApiControllerMock.swift
//  3Degrees
//
//  Created by Gigster Developer on 6/2/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation
import ThreeDegreesClient

@testable import _Degrees

class BaseApiControllerMock : ApiProtocol {
    var shoudFail: Bool = false

    func login(loginForm: LoginForm, loginType: DefaultAPI.LoginType_authLoginTypePut,
               completion:(key: SessionKey?, error: ErrorType?, headers: Dictionary<NSObject, AnyObject>) -> ()) {
        completion(key: SessionKey(), error: shoudFail ? ErrorResponse.RawError(400, NSData(), NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil)) : nil, headers: [String:AnyObject]() as Dictionary<NSObject, AnyObject>)
    }
    func signUp(userForm: UserForm, completion: (key: SessionKey?, error: ErrorType?, headers: Dictionary<NSObject, AnyObject>) -> ()) {
        completion(key: SessionKey(), error: shoudFail ? ErrorResponse.RawError(400, NSData(), NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil)) : nil, headers: [String:AnyObject]() as Dictionary<NSObject, AnyObject>)
    }

    func forgotPassword(email: String, completion: (data: Empty?, error: ErrorType?, headers: Dictionary<NSObject, AnyObject>) -> ()) {
        completion(data: Empty(), error: shoudFail ? ErrorResponse.RawError(400, NSData(), NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil)) : nil, headers: [String:AnyObject]() as Dictionary<NSObject, AnyObject>)
    }

    func logout(completion: (data: Empty?, error: ErrorType?, headers: Dictionary<NSObject, AnyObject>) -> ()) {
        completion(data: Empty(), error: shoudFail ? ErrorResponse.RawError(400, NSData(), NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil)) : nil, headers: [String:AnyObject]() as Dictionary<NSObject, AnyObject>)
    }

    func staticContent(contentType: String,
                       completion: (content: Content?, error: ErrorType?, headers: Dictionary<NSObject, AnyObject>) -> ()) {
        let content = Content()
        content.content = "content"
        completion(content: content, error: shoudFail ? ErrorResponse.RawError(400, NSData(), NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil)) : nil, headers: [String:AnyObject]() as Dictionary<NSObject, AnyObject>)
    }

    func currentUser(completion: (user: PrivateUser?, error: ErrorType?, headers: Dictionary<NSObject, AnyObject>) -> ()) {
        completion(user: PrivateUser(), error: shoudFail ? ErrorResponse.RawError(400, NSData(), NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil)) : nil, headers: [String:AnyObject]() as Dictionary<NSObject, AnyObject>)
    }

    func toggleIsSingle(toggleValue: Bool,
                        completion:(data: Empty?, error: ErrorType?, headers: Dictionary<NSObject, AnyObject>) -> ()) {
        completion(data: Empty(), error: shoudFail ? ErrorResponse.RawError(400, NSData(), NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil)) : nil, headers: [String:AnyObject]() as Dictionary<NSObject, AnyObject>)
    }

    func updateCurrentUser(user: UserForm,
                           completion:(data: Empty?, error: ErrorType?, headers: Dictionary<NSObject, AnyObject>) -> ()) {
        completion(data: Empty(), error: shoudFail ? ErrorResponse.RawError(400, NSData(), NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil)) : nil, headers: [String:AnyObject]() as Dictionary<NSObject, AnyObject>)
    }

    func uploadImage(image: NSData,
                     completion:(data: Image?, error: ErrorType?, headers: Dictionary<NSObject, AnyObject>) -> ()) {
        let image = Image()
        image.url = "https://placehold.it/500x500?text=Rock!"
        completion(data: image, error: shoudFail ? ErrorResponse.RawError(400, NSData(), NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil)) : nil, headers: [String:AnyObject]() as Dictionary<NSObject, AnyObject>)
    }

    func getSingles(page: Int, limit: Int, completion: (users: [User]?, error: ErrorType?, headers: Dictionary<NSObject, AnyObject>) -> ()) {
        completion(users: [User](), error: shoudFail ? ErrorResponse.RawError(400, NSData(), NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil)) : nil, headers: [String:AnyObject]() as Dictionary<NSObject, AnyObject>)
    }

    func getMatchmakers(page: Int, limit: Int, completion: (users: [User]?, error: ErrorType?, headers: Dictionary<NSObject, AnyObject>) -> ()) {
        completion(users: [User](), error: shoudFail ? ErrorResponse.RawError(400, NSData(), NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil)) : nil, headers: [String:AnyObject]() as Dictionary<NSObject, AnyObject>)
    }

    func deleteConnection(username: String, completion: (data: Empty?, error: ErrorType?, headers: Dictionary<NSObject, AnyObject>) -> ()) {
        completion(data: Empty(), error: shoudFail ? ErrorResponse.RawError(400, NSData(), NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil)) : nil, headers: [String:AnyObject]() as Dictionary<NSObject, AnyObject>)
    }

    func getUsers(requestModel: UsersRequestModel,
                  completion: ((data: [User]?, error: ErrorType?, headers: Dictionary<NSObject, AnyObject>) -> Void)) {
        let count = arc4random_uniform(100)
        let users: [User] = (0...count).map {
            let user = User()
            user.username = "un\($0)"
            return user
        }
        completion(data: users, error: shoudFail ? ErrorResponse.RawError(400, NSData(), NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil)) : nil, headers: [String:AnyObject]() as Dictionary<NSObject, AnyObject>)
    }

    func addUserToMyNetwork(username: String, completion: (data: Empty?, error:ErrorType?, headers: Dictionary<NSObject, AnyObject>) -> ()) {
        completion(data: Empty(), error: shoudFail ? ErrorResponse.RawError(400, NSData(), NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil)) : nil, headers: [String:AnyObject]() as Dictionary<NSObject, AnyObject>)
    }

    func getMessages(username: String, limit: Int, page: Int, completion: (messages: [Message]?, error: ErrorType?, headers: Dictionary<NSObject, AnyObject>) -> ()) {
        completion(messages: [Message](), error: shoudFail ? ErrorResponse.RawError(400, NSData(), NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil)) : nil, headers: [String:AnyObject]() as Dictionary<NSObject, AnyObject>)
    }

    func sendMessage(username: String, message: MessageForm, completion: (data: Empty?, error: ErrorType?, headers: Dictionary<NSObject, AnyObject>) -> ()) {
        completion(data: Empty(), error: shoudFail ? ErrorResponse.RawError(400, NSData(), NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil)) : nil, headers: [String:AnyObject]() as Dictionary<NSObject, AnyObject>)
    }

    func sendImage(username: String,
                   image: NSData,
                   completion: (
                        data: Image?,
                        error: ErrorType?,
                        headers: Dictionary<NSObject, AnyObject>) -> ()) {
        let image = Image()
        image.url = "https://placehold.it/500x500?text=Rock!"
        completion(data: image, error: shoudFail ? ErrorResponse.RawError(400, NSData(), NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil)) : nil, headers: [String:AnyObject]() as Dictionary<NSObject, AnyObject>)
    }

    func matchWith(gender: DefaultAPI.Gender_meMatchWithGenderPut,
                   completion: (data: Empty?,
                                error: ErrorType?,
                                headers: Dictionary<NSObject, AnyObject>) -> ()) {
        completion(data: Empty(), error: shoudFail ? ErrorResponse.RawError(400, NSData(), NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil)) : nil, headers: [String:AnyObject]() as Dictionary<NSObject, AnyObject>)
    }

    func switchPushNotifications(deviceToken: String?, value: Bool, completion: (data: Empty?, error: ErrorType?, headers: Dictionary<NSObject, AnyObject>) -> ()) {
        completion(data: Empty(), error: shoudFail ? ErrorResponse.RawError(400, NSData(), NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil)) : nil, headers: [String:AnyObject]() as Dictionary<NSObject, AnyObject>)
    }

    func pushNotificationsValue(completion: (data: Empty?, error: ErrorType?, headers: Dictionary<NSObject, AnyObject>) -> ()) {
        completion(data: Empty(), error: shoudFail ? ErrorResponse.RawError(400, NSData(), NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil)) : nil, headers: [String:AnyObject]() as Dictionary<NSObject, AnyObject>)
    }

    func getDates(page: Int,
                  limit: Int,
                  completion: (
        users:[User]?,
        error:ErrorType?,
        headers: Dictionary<NSObject, AnyObject>) -> ()) {
        completion(users: [User](), error: shoudFail ? ErrorResponse.RawError(400, NSData(), NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil)) : nil, headers: [String:AnyObject]() as Dictionary<NSObject, AnyObject>)
    }

    func getActivities(mode: Mode,
                       limit: Int,
                       page: Int,
                       completion: (
                            data: [Activity]?,
                            error: ErrorType?,
                            headers: Dictionary<NSObject, AnyObject>) -> ()) {
        completion(data: [Activity](),
                   error: shoudFail ?
                          ErrorResponse.RawError(400,
                                                 NSData(),
                                                 NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil)) :
                          nil,
                   headers: [String:AnyObject]() as Dictionary<NSObject, AnyObject>)
    }

    func markActivityItemAsSeen(id: Int,
                                completion: (
        data: Empty?,
        error: ErrorType?,
        headers: Dictionary<NSObject, AnyObject>) -> ()) {
        completion(data: Empty(),
                   error: shoudFail ?
                    ErrorResponse.RawError(400,
                        NSData(),
                        NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil)) :
                    nil,
                   headers: [String:AnyObject]() as Dictionary<NSObject, AnyObject>)
    }

    func getUser(username: String,
                 completion: (
                    user: User?,
                    error: ErrorType?,
                    headers: Dictionary<NSObject, AnyObject>) ->()) {
        completion(user: User(),
                   error: shoudFail ?
                    ErrorResponse.RawError(400,
                        NSData(),
                        NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil)) :
                    nil,
                   headers: [String:AnyObject]() as Dictionary<NSObject, AnyObject>)
    }

    func acceptConnectionInvite(username: String,
                                completion: (
                                    data: Empty?,
                                    error: ErrorType?,
                                    headers: Dictionary<NSObject, AnyObject>) -> ()) {
        completion(data: Empty(),
                   error: shoudFail ?
                    ErrorResponse.RawError(400,
                        NSData(),
                        NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil)) :
                    nil,
                   headers: [String:AnyObject]() as Dictionary<NSObject, AnyObject>)
    }

    func declineConnectionInvite(username: String,
                                 completion: (
        data: Empty?,
        error: ErrorType?,
        headers: Dictionary<NSObject, AnyObject>) -> ()) {
        completion(data: Empty(),
                   error: shoudFail ?
                    ErrorResponse.RawError(400,
                        NSData(),
                        NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil)) :
                    nil,
                   headers: [String:AnyObject]() as Dictionary<NSObject, AnyObject>)
    }

    func getMySinglesForPairUp(page: Int,
                               limit: Int,
                               completion: (
                                    data: [User]?,
                                    error: ErrorType?,
                                    headers: Dictionary<NSObject, AnyObject>) -> ()) {
        completion(data: [User](),
                   error: shoudFail ?
                    ErrorResponse.RawError(400,
                        NSData(),
                        NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil)) :
                    nil,
                   headers: [String:AnyObject]() as Dictionary<NSObject, AnyObject>)
    }

    func getPotentialMatches(username: String,
                             page: Int,
                             limit: Int,
                             ageFrom: Int?,
                             ageTo: Int?,
                             matchmakerUsername: String?,
                             gender: DefaultAPI.Gender_usersUsernamePotentialMatchesGet?,
                             completion: (
                                data: [User]?,
                                error: ErrorType?,
                                headers: Dictionary<NSObject, AnyObject>) -> ()) {
        completion(data: [User](),
                   error: shoudFail ?
                    ErrorResponse.RawError(400,
                        NSData(),
                        NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil)) :
                    nil,
                   headers: [String:AnyObject]() as Dictionary<NSObject, AnyObject>)
    }

    func pairUp(username: String,
                matchUsername: String,
                completion:(
                    data: Empty?,
                    error: ErrorType?,
                    headers: Dictionary<NSObject, AnyObject>) -> ()) {
        completion(data: Empty(),
                   error: shoudFail ?
                    ErrorResponse.RawError(400,
                        NSData(),
                        NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil)) :
                    nil,
                   headers: [String:AnyObject]() as Dictionary<NSObject, AnyObject>)
    }

    func markMatchAsViewed(username: String,
                           matchUsername: String,
                           completion: (
                                data: Empty?,
                                error: ErrorType?,
                                headers: Dictionary<NSObject, AnyObject>) -> ()) {
        completion(data: Empty(),
                   error: shoudFail ?
                    ErrorResponse.RawError(400,
                        NSData(),
                        NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil)) :
                    nil,
                   headers: [String:AnyObject]() as Dictionary<NSObject, AnyObject>)
    }

    func getDatesProposals(limit: Int,
                           page: Int,
                           completion: (data: [User]?,
                                        error: ErrorType?,
                                        headers: Dictionary<NSObject, AnyObject>) -> ()) {
        completion(data: [User](),
                   error: shoudFail ?
                    ErrorResponse.RawError(400,
                        NSData(),
                        NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil)) :
                    nil,
                   headers: [String:AnyObject]() as Dictionary<NSObject, AnyObject>)
    }

    func acceptDate(username: String,
                    completion: (data: Status?,
                                error: ErrorType?,
                                headers: Dictionary<NSObject, AnyObject>) -> ()) {
        completion(data: Status(),
                   error: shoudFail ?
                    ErrorResponse.RawError(400,
                        NSData(),
                        NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil)) :
                    nil,
                   headers: [String:AnyObject]() as Dictionary<NSObject, AnyObject>)
    }

    func declineDate(username: String,
                     completion: (data: Empty?,
                                    error: ErrorType?,
                                    headers: Dictionary<NSObject, AnyObject>) -> ()) {
        completion(data: Empty(),
                   error: shoudFail ?
                    ErrorResponse.RawError(400,
                        NSData(),
                        NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil)) :
                    nil,
                   headers: [String:AnyObject]() as Dictionary<NSObject, AnyObject>)
    }

    func suggestDates(username: String,
                      dates: [NSDate],
                      completion: (data: Empty?,
                                    error: ErrorType?,
                                    headers: Dictionary<NSObject, AnyObject>) -> ()) {
        completion(data: Empty(),
                   error: shoudFail ?
                    ErrorResponse.RawError(400,
                        NSData(),
                        NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil)) :
                    nil,
                   headers: [String:AnyObject]() as Dictionary<NSObject, AnyObject>)
    }

    func acceptSuggestedDate(username: String,
                             date: NSDate,
                             completion: (data: Empty?,
                                            error: ErrorType?,
                                            headers: Dictionary<NSObject, AnyObject>) -> ()) {
        completion(data: Empty(),
                   error: shoudFail ?
                    ErrorResponse.RawError(400,
                        NSData(),
                        NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil)) :
                    nil,
                   headers: [String:AnyObject]() as Dictionary<NSObject, AnyObject>)
    }

    func getSuggestedTimes(username: String, completion: (data: Dates?, error: ErrorType?, headers: Dictionary<NSObject, AnyObject>) -> ()) {
        completion(data: Dates(),
                   error: shoudFail ?
                            ErrorResponse.RawError(400,
                                NSData(),
                                NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil)) :
                            nil,
                   headers: [String:AnyObject]() as Dictionary<NSObject, AnyObject>)
    }

    func resetPass(password: String,
                   completion: (data: SessionKey?,
                                error: ErrorType?,
                                headers: Dictionary<NSObject, AnyObject>) -> ()) {
        let sessionKey = SessionKey()
        sessionKey.key = "session_key_for_tests"
        completion(data: sessionKey,
                   error: shoudFail ?
                    ErrorResponse.RawError(400,
                        NSData(),
                        NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil)) :
                        nil,
                   headers: [String:AnyObject]() as Dictionary<NSObject, AnyObject>)
    }
}
