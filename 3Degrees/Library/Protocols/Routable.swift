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

private let _router = Router()
private var _routerLoaded = false

private let _activityApi: ActivityApiProtocol = ActivityApiController()
private let _staticContentApi: StaticContentApiProtocol = StaticContentApiController()

protocol Routable: class, Loggable {
    func route(uri: String)
    var router: Router { get }
    var appNavigator: AppNavigator? { get }
}

extension Routable {
    func route(uri: String) {
        var path = "/not-found"
        if let components = NSURLComponents(URL: NSURL(fileURLWithPath: uri), resolvingAgainstBaseURL: true) {
            path = components.path ?? path
        }
        debug("path: \(path)")
        if (self.router.match(NSURL(fileURLWithPath: "routerapp:/" + path)) == nil) {
            error("Path [\(path)] not found.")
        }
    }

    var router: Router {
        self.initRouter()
        return _router
    }
    
    func routeToMessages(username: String) {
        route("\(Constants.Routes.Messages.rawValue)/\(username)")
    }

    func routeToProfile(username: String) {
        route("\(Constants.Routes.Users.rawValue)/\(username)")
    }
    
    private func initRouter() {
        if !_routerLoaded {
            debug("loading router...")
            _router.bind("\(Constants.Routes.Users.rawValue)/:username") { (req) in
                self.withUser(req.param("username")!) {[unowned self] (user) in
                    guard let viewController = R.storyboard.myNetworkScene.dateProfileViewController()
                        else { return }
                    viewController.user = user
                    viewController.selectedTab = MyNetworkTab.First
                    self.appNavigator?.showVcAction(vc: viewController)
                }
            }
            _router.bind("\(Constants.Routes.Messages.rawValue)/:username") { (req) in
                self.withUser(req.param("username")!) {[weak self](user) in
                    guard let viewController = R.storyboard.myNetworkScene.chatViewController()
                        else { return }
                    viewController.interlocutor = user
                    self?.appNavigator?.showVcAction(vc: viewController)
                }
            }
            StaticContentType.allPageContent.forEach { (contentType) in
                _router.bind("/\(contentType.rawValue)") { (req) in
                    guard let viewController = R.storyboard.userProfileScene.staticContentViewController()
                        else { return }
                    viewController.actionType = AccountAction.fromStaticContentType(contentType)
                    self.appNavigator?.showVcAction(vc: viewController)
                }
            }
            _routerLoaded = true
        }
    }
    
    private func withUser(username: String, completion:(User) -> ()) {
        _activityApi.getUser(username) { (user) in
            completion(user)
        }
    }
}