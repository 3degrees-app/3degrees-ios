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
    func show(viewController: UIViewController, withMenu: Bool)
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

    func routeToStaticContent(staticContentType: StaticContentType, withMenu: Bool = true) {
        route("\(withMenu ? "" : ":root:")/\(staticContentType.rawValue)")
    }

    func routeToMessages(username: String, withMenu: Bool = true) {
        route("\(withMenu ? "" : ":root:")\(Constants.Routes.Messages.rawValue)/\(username)")
    }

    func routeToProfile(username: String, withMenu: Bool = true) {
        route("\(withMenu ? "" : ":root:")\(Constants.Routes.Users.rawValue)/\(username)")
    }
    
    func initRouter() {
        if !self.router.hasRoutes() {
            debug("loading router...")
            self.bind("\(Constants.Routes.Users.rawValue)/:username") { (req, withMenu) in
                self.withUser(req.param("username")!) {[unowned self] (user) in
                    guard let viewController = R.storyboard.myNetworkScene.dateProfileViewController()
                        else { return }
                    viewController.user = user
                    viewController.selectedTab = MyNetworkTab.First
                    self.show(viewController, withMenu: withMenu)
                }
            }
            self.bind("\(Constants.Routes.Messages.rawValue)/:username") { (req, withMenu) in
                self.withUser(req.param("username")!) {[weak self](user) in
                    guard let viewController = R.storyboard.myNetworkScene.chatViewController()
                        else { return }
                    viewController.interlocutor = user
                    self?.show(viewController, withMenu: withMenu)
                }
            }
            StaticContentType.allPageContent.forEach { (contentType) in
                self.bind("/\(contentType.rawValue)") { (req, withMenu) in
                    guard let viewController = R.storyboard.userProfileScene.staticContentViewController()
                        else { return }
                    viewController.actionType = AccountAction.fromStaticContentType(contentType)
                    self.show(viewController, withMenu: withMenu)
                }
            }
            self.bind("/date-proposal") { (req, withMenu) in
                self.show(R.storyboard.dateProposalScene.dateProposalsCollectionViewController()!, withMenu: withMenu)
            }
            self.bind("/get-started") { (req, withMenu) in
                self.show(R.storyboard.commonScene.onboardingPageViewController()!, withMenu: withMenu)
            }
            self.bind("/pair-up") { (req, withMenu) in
                self.show(R.storyboard.pairUpScene.pairUpViewController()!, withMenu: withMenu)
            }
            self.bind("/select-mode") { (req, withMenu) in
                self.show(R.storyboard.commonScene.modeViewController()!, withMenu: withMenu)
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

    private func bind(route: String, completion: (Request, Bool) -> ()) {
        self.router.bind(route) { (req) in
            completion(req, true)
        }
        self.router.bind(":root:\(route)") { (req) in
            completion(req, false)
        }
    }
}