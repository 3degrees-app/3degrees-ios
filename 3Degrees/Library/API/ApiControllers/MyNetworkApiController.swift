//
//  MyNetworkApiController.swift
//  3Degrees
//
//  Created by Gigster Developer on 6/3/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation
import ThreeDegreesClient

protocol MyNetworkApiProtocol: BaseApiProtocol {
    func getSingles(page: Int, limit: Int, completion:([User]) -> ())
    func getMatchmakers(page: Int, limit: Int, completion:([User]) -> ())
    func getDates(page: Int, limit: Int, completion:[Match] ->())
    func deleteConnection(username: String, completion:() -> ())
    func getUsers(requestModel: UsersRequestModel, completion:([User]) -> ())
    func addUser(username: String, completion:() -> ())
    func getMessages(username: String, page: Int, limit: Int, completion:([Message]) -> ())
    func sendMessage(username: String, message: Message, completion:() -> ())
    func sendImage(username: String, image: NSData, completion:(imageUrl: String?) -> ())
}

struct MyNetworkApiController: MyNetworkApiProtocol {
    var api: ApiProtocol = ApiController()

    func getSingles(page: Int, limit: Int, completion:([User]) -> ()) {
        showActivityIndicator()
        api.getSingles(page, limit: limit) { (singles, error, headers) in
            guard self.handleError(error, getErrorMessage: self.getErrorMessage) else { return }
            guard let singles = singles else { return }
            completion(singles.map { $0 as User })
            self.hideActivityIndicator()
        }
    }

    func getMatchmakers(page: Int, limit: Int, completion:([User]) -> ()) {
        showActivityIndicator()
        api.getMatchmakers(page, limit: limit) { (matchmakers, error, headers) in
            guard self.handleError(error, getErrorMessage: self.getErrorMessage)
                else { return }
            guard let matchmakers = matchmakers else { return }
            completion(matchmakers)
            self.hideActivityIndicator()
        }
    }

    func getDates(page: Int, limit: Int, completion:[Match] ->()) {
        showActivityIndicator()
        api.getDates(page, limit: limit) { (dates, error, headers) in
            guard self.handleError(error, getErrorMessage: self.getErrorMessage)
                else { return }
            guard let dates = dates else { return }
            completion(dates)
            self.hideActivityIndicator()
        }
    }

    func deleteConnection(username: String, completion:() -> ()) {
        showActivityIndicator()
        api.deleteConnection(username) { (data, error, headers) in
            guard self.handleError(error, getErrorMessage: self.getErrorMessage)
                else { return }
            completion()
            self.hideActivityIndicator()
        }
    }

    func getUsers(requestModel: UsersRequestModel, completion:([User]) -> ()) {
        showActivityIndicator()
        api.getUsers(requestModel) { (data, error, headers) in
            guard self.handleError(error, getErrorMessage: self.getErrorMessage) else { return }
            guard let users = data else { return }
            completion(users)
            self.hideActivityIndicator()
        }
    }

    func addUser(username: String, completion:() -> ()) {
        showActivityIndicator()
        api.addUserToMyNetwork(username) { (data, error, headers) in
            guard self.handleError(error, getErrorMessage: self.getErrorMessage) else { return }
            completion()
            self.hideActivityIndicator()
        }
    }

    func getMessages(username: String, page: Int, limit: Int, completion:([Message]) -> ()) {
        showActivityIndicator()
        api.getMessages(username, limit: limit, page: page) { (messages, error, headers) in
            guard self.handleError(error, getErrorMessage: self.getChatErrorMessages) else { return }
            guard let messages = messages else { return }
            completion(messages)
            self.hideActivityIndicator()
        }
    }

    func sendMessage(username: String, message: Message, completion:() -> ()) {
        showActivityIndicator()
        let messageForm = MessageForm()
        messageForm.message = message.message
        api.sendMessage(username, message: messageForm) { (data, error, headers) in
            guard self.handleError(error, getErrorMessage: self.getChatErrorMessages) else { return }
            completion()
            self.hideActivityIndicator()
        }
    }

    func sendImage(username: String, image: NSData, completion:(imageUrl: String?) -> ()) {
        showActivityIndicator()
        api.sendImage(username, image: image) { (data, error, headers) in
            guard self.handleError(error, getErrorMessage: self.getChatErrorMessages) else { return }
            completion(imageUrl: data?.url)
            self.hideActivityIndicator()
        }
    }

    func getErrorMessage(error: ErrorType?) -> String? {
        if let e = error {
            switch e {
            case ErrorResponse.singlesGet403(let e):
                AppController.shared.logOut()
                return e.message
            case ErrorResponse.matchmakersGet403(let e):
                AppController.shared.logOut()
                return e.message
            case ErrorResponse.matchesGet403(let e):
                AppController.shared.logOut()
                return e.message
            case ErrorResponse.connectionsUsernameDelete403(let e):
                AppController.shared.logOut()
                return e.message
            case ErrorResponse.usersUsernameConnectionsPut403(let e):
                AppController.shared.logOut()
                return e.message
            case ErrorResponse.usersUsernameConnectionsPut404(let e): return e.message
            case ErrorResponse.usersGet403(let e):
                AppController.shared.logOut()
                return e.message
            default:
                return ""
            }
        }
        return nil
    }

    func getChatErrorMessages(error: ErrorType?) -> String? {
        if let e = error {
            switch e {
            case ErrorResponse.messagesUsernameGet403(let e):
                AppController.shared.logOut()
                return e.message
            case ErrorResponse.messagesUsernameGet404(let e): return e.message
            case ErrorResponse.messagesUsernameImagePost400(let e): return e.message
            case ErrorResponse.messagesUsernameImagePost403(let e):
                AppController.shared.logOut()
                return e.message
            case ErrorResponse.messagesUsernameImagePost413(let e): return e.message
            case ErrorResponse.messagesUsernamePut403(let e):
                AppController.shared.logOut()
                return e.message
            case ErrorResponse.messagesUsernamePut404(let e): return e.message
            default:
                return ""
            }
        }
        return nil
    }
}
