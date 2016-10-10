//
//  MyNetworkApiControllerMock.swift
//  3Degrees
//
//  Created by Gigster Developer on 6/6/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation
import ThreeDegreesClient

@testable import _Degrees

class MyNetworkApiControllerMock: MyNetworkApiProtocol {
    var api: ApiProtocol = BaseApiControllerMock()

    func getSingles(page: Int, limit: Int, completion:([User]) -> ()) {
        api.getSingles(page, limit: limit) { (singles, error, headers) in
            guard error == nil else { return }
            completion(singles!)
        }
    }

    func getMatchmakers(page: Int, limit: Int, completion:([User]) -> ()) {
        api.getMatchmakers(page, limit: limit) { (matchmakers, error, headers) in
            guard error == nil else { return }
            completion(matchmakers!)
        }
    }

    func getDates(page: Int, limit: Int, completion: [User] -> ()) {
        api.getDates(page, limit: limit) { (users, error, headers) in
            guard error == nil else { return }
            completion(users!)
        }
    }

    func deleteConnection(username: String, completion:() -> ()) {
        api.deleteConnection(username) { (data, error, headers) in
            guard error == nil else { return }
            completion()
        }
    }

    func getUsers(requestModel: UsersRequestModel, completion:([User]) -> ()) {
        api.getUsers(requestModel) { (data, error, headers) in
            guard error == nil else { return }
            completion(data!)
        }
    }

    func addUser(username: String, completion:() -> ()) {
        api.addUserToMyNetwork(username) { (data, error, headers) in
            guard error == nil else { return }
            completion()
        }
    }

    func getMessages(username: String, page: Int, limit: Int, completion:([Message]) -> ()) {
        api.getMessages(username, limit: limit, page: page) { (messages, error, headers) in
            guard error == nil else { return }
            completion(messages!.isEmpty ? [Message()] : messages!)
        }
    }

    func sendMessage(username: String, message: Message, completion:() -> ()) {
        let messageForm = MessageForm()
        messageForm.message = message.message
        api.sendMessage(username, message: messageForm) { (data, error, headers) in
            guard error == nil else { return }
            completion()
        }
    }

    func sendImage(username: String, image: NSData, completion:(imageUrl: String?) -> ()) {
        api.sendImage(username, image: image) {
            (data: Image?, error: ErrorType?, headers: Dictionary<NSObject, AnyObject>) in
            guard error == nil else { return }
            completion(imageUrl: data?.url)
        }
    }
}
