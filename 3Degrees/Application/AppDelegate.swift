//
//  AppDelegate.swift
//  3Degrees
//
//  Created by Gigster Developer on 4/25/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import IQKeyboardManager
import Router

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        FBSDKApplicationDelegate.sharedInstance()
                                .application(
                                    application,
                                    didFinishLaunchingWithOptions: launchOptions)
        AppController.shared.handleAppStart(launchOptions)
        IQKeyboardManager.sharedManager().enable = true
        return true
    }

    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
        application.applicationIconBadgeNumber = 0
    }

    func application(application: UIApplication,
                     didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        guard application.applicationState != .Active else { return }
        guard let info = userInfo as? [String: AnyObject] else { return }
        AppController.shared.handleRemoteNotificaiton(info)
    }

    func application(
        application: UIApplication,
        didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        AppController.shared.handleRegisteredNotificationSettings(notificationSettings)
    }

    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        AppController.shared.handlePushNotificationsRegistrationCompleted(deviceToken)
    }

    func application(application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        AppController.shared.handlePushNotificationsRegistrationFailed()
    }

    func application(application: UIApplication,
                     openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance()
                                              .application(application,
                                                           openURL: url,
                                                           sourceApplication: sourceApplication,
                                                           annotation: annotation)
        if !handled {
            guard AppController.shared.router.match(url) != nil else { return handled }
            return true
        }
        return handled
    }
}
