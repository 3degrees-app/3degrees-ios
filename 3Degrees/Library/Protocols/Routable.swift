//
//  Routable.swift
//  3Degrees
//
//  Created by Ryan Martin on 11/12/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation
import Router
import ThreeDegreesClient

private let _activityApi: ActivityApiProtocol = ActivityApiController()
private let _staticContentApi: StaticContentApiProtocol = StaticContentApiController()

protocol Routable: class, Loggable {
    func route(uri: String)
    var router: Router { get }
    func show(viewController: UIViewController)
}

extension Routable {
    func route(url: NSURL) {
        self.initRouter()
        if (self.router.match(url) == nil) {
            error("Path [\(url.path)] not found.")
        }
    }

    func route(uri: String) {
        self.route(NSURL(fileURLWithPath: uri))
    }

    func routeToStaticContent(staticContentType: StaticContentType) {
        route("/\(staticContentType.rawValue)")
    }

    func routeToMessages(username: String) {
        route("\(Constants.Routes.Messages.rawValue)/\(username)")
    }

    func routeToProfile(username: String) {
        route("\(Constants.Routes.Users.rawValue)/\(username)")
    }
    
    func initRouter() {
        if !self.router.hasRoutes() {
            debug("loading router...")
            self.router.bind("\(Constants.Routes.Users.rawValue)/:username") { (req) in
                self.withUser(req.param("username")!) {[unowned self] (user) in
                    guard let viewController = R.storyboard.myNetworkScene.dateProfileViewController()
                        else { return }
                    viewController.user = user
                    viewController.selectedTab = MyNetworkTab.First
                    self.show(viewController)
                }
            }
            self.router.bind("\(Constants.Routes.Messages.rawValue)/:username") { (req) in
                self.withUser(req.param("username")!) {[weak self](user) in
                    guard let viewController = R.storyboard.myNetworkScene.chatViewController()
                        else { return }
                    viewController.interlocutor = user
                    self?.show(viewController)
                }
            }
            StaticContentType.allPageContent.forEach { (contentType) in
                self.router.bind("/\(contentType.rawValue)") { (req) in
                    guard let viewController = R.storyboard.userProfileScene.staticContentViewController()
                        else { return }
                    viewController.actionType = AccountAction.fromStaticContentType(contentType)
                    self.show(viewController)
                }
            }
            // TODO: Make this work
//            router.bind("/reset_password") { (req) in
//                guard let sessionKey = req.query("session-key") else { return }
//                ThreeDegreesClientAPI.customHeaders.updateValue(sessionKey,
//                                                                forKey: Constants.Api.SessionKeyHeader)
//                let alertTitle = R.string.localizable.resetPassTitle()
//                let alertMessage = R.string.localizable.resetPassMessage()
//                let alert = Alert(title: alertTitle, message: alertMessage)
//                alert.configureResetPassAlertController(ResetPasswordViewModel()) {
//                    self.handleAutoLogin()
//                }
//                alert.show(animated: true)
//            }
        }
    }
    
    private func withUser(username: String, completion:(User) -> ()) {
        _activityApi.getUser(username) { (user) in
            completion(user)
        }
    }
}