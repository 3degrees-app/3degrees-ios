//
//  AppController.swift
//  3Degrees
//
//  Created by Gigster Developer on 4/27/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import Bond
import DualSlideMenu
import Rswift
import SVProgressHUD
import ThreeDegreesClient
import Router
import LKAlertController
import Fabric
import Crashlytics

protocol AppControllerProtocol {
    func handleAppStart(launchOptions: [NSObject: AnyObject]?)
    func handleRegisteredNotificationSettings(settings: UIUserNotificationSettings)
    func handlePushNotificationsRegistrationFailed()
    func handlePushNotificationsRegistrationCompleted(token: NSData)

    func handleRemoteNotificaiton(userInfo: [String: AnyObject])
}

struct AppController: AppControllerProtocol {
    static let shared: AppController = AppController()

    var cacheController: CacheProtocol
    let currentUser: Observable<PrivateUser?>
    let currentUserImage: Observable<String?>
    let leftMenu: DualSlideMenuViewController?
    let currentUserMode: Observable<Mode>
    let router: Router

    init() {
        cacheController = CacheController()
        currentUserMode = Observable(.Matchmaker)
        currentUserImage = Observable(nil)
        currentUser = Observable(nil)

        router = Router()

        let userProfileScene = R.storyboard.userProfileScene()
        let leftMenuViewController = userProfileScene.instantiateInitialViewController()
        let commonScene = R.storyboard.commonScene()
        let tabbarController = commonScene.instantiateViewControllerWithIdentifier(
            "TabBarViewController"
        )
        leftMenu = DualSlideMenuViewController(
            mainViewController: tabbarController,
            leftMenuViewController: leftMenuViewController!
        )
        leftMenu?.leftSideOffset = 0

        currentUserMode.observeNew {(mode) in
            self.cacheController.lastMode = mode
        }
    }

    func handleRemoteNotificaiton(userInfo: [String: AnyObject]) {
        modeExtract: if let modeString = userInfo["mode"] as? String {
            guard let mode = Mode(rawValue: modeString)
                else { break modeExtract }
            currentUserMode.next(mode)
        }
        handleAutoLogin()
        guard let token = cacheController.getAuthToken() where !token.isEmpty else { return }
        guard let tabBarController = leftMenu?.mainView as? TabBarViewController else { return }
        tabBarController.setUpContent(currentUserMode.value)
        tabBarController.selectActivityFeedTab()
    }

    func handleAppStart(launchOptions: [NSObject: AnyObject]?) {
        Fabric.with([Crashlytics.self])
        applyDefaultStyles()
        registerRoutes()
        if let launchOptions = launchOptions {
            if let url = launchOptions[UIApplicationLaunchOptionsURLKey] as? NSURL {
                AppController.shared.router.match(url)
            } else if let remoteNotificaiton =
                launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey] as? [String: AnyObject] {
                handleRemoteNotificaiton(remoteNotificaiton)
            } else {
                handleAutoLogin()
            }
        } else {
            handleAutoLogin()
        }
    }

    func setupMainAppContent() {
        guard let appDelegate = UIApplication.sharedApplication().delegate else { return }
        guard let w = appDelegate.window else { return }
        UIView.animateWithDuration(0.5,
                                   delay: 0,
                                   options: [.TransitionCrossDissolve],
                                   animations: {
                w?.rootViewController = AppController.shared.leftMenu
            }, completion: nil)
    }

    func logOut() {
        cacheController.loggedOut()
        ThreeDegreesClientAPI.customHeaders.removeValueForKey(Constants.Api.SessionKeyHeader)
        guard let w = getMainWindow() else { return }
        let viewController = R.storyboard.authenticationScene()
                                         .instantiateInitialViewController()
        UIView.animateWithDuration(1,
                                   delay: 0,
                                   options: [.TransitionCrossDissolve],
                                   animations: {
            w.rootViewController = viewController
        }, completion: nil)
    }

    func handleAutoLogin() {
        guard let token = cacheController.getAuthToken() where !token.isEmpty else { return }
        if let mode = cacheController.lastMode {
            AppController.shared.setupMainAppContent()
            AppController.shared.currentUserMode.next(mode)
            guard let tabBar = leftMenu?.mainView as? TabBarViewController
                else { return }
            tabBar.setUpContent(mode)
        } else {
            guard let w = getMainWindow() else { return }
            w.rootViewController = R.storyboard.commonScene.modeViewController()
        }
    }

    func registerForRemoteNotifications() {
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert],
                                                              categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(
            notificationSettings
        )
    }

    func unregisterForRemoteNotifications() {
        UIApplication.sharedApplication().unregisterForRemoteNotifications()
        UserApiController().switchPushNotifications(nil, value: false) {_ in
            self.cacheController.pushNotificationsSettingChanged(false)
        }
    }

    func handlePushNotificationsRegistrationFailed() {
        SVProgressHUD.showErrorWithStatus(
            R.string.localizable.pushNotificationsFailedRegistration()
        )
        UserApiController().switchPushNotifications(nil, value: false) {
        }
    }

    func handlePushNotificationsRegistrationCompleted(token: NSData) {
        let tokenString = getStringDeviceToken(token)
        cacheController.setPushNotificationToken(tokenString)
        UserApiController().pushNotificationsValue { (value) in
            guard value else { return }
            UserApiController().switchPushNotifications(tokenString, value: true) {
                self.cacheController.pushNotificationsSettingChanged(true)
            }
        }
    }

    func handleRegisteredNotificationSettings(settings: UIUserNotificationSettings) {
        if settings.types != .None {
            UIApplication.sharedApplication().registerForRemoteNotifications()
        }
    }

    private func registerRoutes() {
        router.bind("/reset_password") { (req) in
            guard let sessionKey = req.query("session-key") else { return }
            ThreeDegreesClientAPI.customHeaders.updateValue(sessionKey,
                                                            forKey: Constants.Api.SessionKeyHeader)
            let alertTitle = R.string.localizable.resetPassTitle()
            let alertMessage = R.string.localizable.resetPassMessage()
            let alert = Alert(title: alertTitle, message: alertMessage)
            alert.configureResetPassAlertController(ResetPasswordViewModel()) {
                self.handleAutoLogin()
            }
            alert.show(animated: true)
        }

    }

    private func applyDefaultStyles() {
        applyNavBarStyles()
        applyWindowAndViewsStyles()
        applyDefaultActivityIndicatorStyles()
    }

    private func registerRemoteNotificationsSettings() {
        let settings = UIUserNotificationSettings(forTypes: [.Sound, .Alert, .Badge], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    }

    private func applyDefaultActivityIndicatorStyles() {
        SVProgressHUD.setDefaultStyle(.Dark)
        SVProgressHUD.setDefaultMaskType(.Black)
    }

    private func applyNavBarStyles() {
        UINavigationBar.appearance().tintColor = Constants.NavBar.TintColor
        UINavigationBar.appearance().barTintColor = Constants.NavBar.BarTintColor
        UINavigationBar.appearance().shadowImage = Constants.NavBar.ShadowImage
        UINavigationBar.appearance().translucent = Constants.NavBar.Translucent
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName: Constants.NavBar.TintColor
        ]
    }

    private func applyWindowAndViewsStyles() {
        UIWindow.appearance().tintColor = Constants.ViewOnBackground.Color
    }

    private func getStringDeviceToken(deviceToken: NSData) -> String {
        return deviceToken.description.characters
            .map { (c) -> String in
                switch c {
                case "<":
                    return ""
                case ">":
                    return ""
                case " ":
                    return ""
                default:
                    return String(c)
                }
            }.reduce("") { $0 + $1 }
    }

    private func getMainWindow() -> UIWindow? {
        guard let w = UIApplication.sharedApplication().delegate?.window
            else { return nil }
        return w
    }
}
