//
//  CacheController.swift
//  3Degrees
//
//  Created by Gigster Developer on 4/27/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation
import AwesomeCache

protocol CacheProtocol {
    var lastMode: Mode? { get set }

    var pushNotificationToken: String? { get set }
    func setPushNotificationToken(token: String?)

    var firstTimeInSingleMode: Bool { get set }
    func setFirstTimeInSingleMode(value: Bool)

    func loggedIn(token: String?)

    func loggedOut()

    func getAuthToken() -> String?

    func pushNotificationsSettingChanged(isEnabled: Bool)

    func pushNotificationsSetting() -> Bool
}

struct CacheController: CacheProtocol {
    private let tokenKey = "AuthToken"
    private let pushNotificationsSettingsKey = "pushNotificationsKey"
    private let modeKey = "modeKey"
    private let pushNotificationTokenKey = "pushUuid"
    private let firstTimeInSingleModeKey = "firstTimeInSingleMode"

    let cache: Cache<NSString>?


    init() {
        cache = try? Cache<NSString>(name: "3DCache")
    }

    var lastMode: Mode? {
        get {
            guard let modeString = getStringForKey(modeKey) else { return nil }
            guard let mode = Mode(rawValue: modeString) else { return nil }
            return mode
        }
        set {
            guard let unwrappedMode = newValue else { return }
            cache?.setObject(unwrappedMode.rawValue, forKey: modeKey, expires: .Never)
        }
    }

    var pushNotificationToken: String? {
        get {
            guard let token = getStringForKey(pushNotificationTokenKey) else { return nil }
            return token
        }
        set {
            setPushNotificationToken(newValue)
        }
    }

    var firstTimeInSingleMode: Bool {
        get {
            guard let firstTime = getStringForKey(firstTimeInSingleModeKey) else {
                return true
            }
            return NSString(string: firstTime).boolValue
        }
        set {
            setFirstTimeInSingleMode(newValue)
        }
    }

    func setFirstTimeInSingleMode(value: Bool) {
        cache?.setObject(String(value), forKey: firstTimeInSingleModeKey, expires: .Never)
    }

    func setPushNotificationToken(token: String?) {
        guard let token = token else {
            cache?.removeObjectForKey(pushNotificationTokenKey)
            return
        }
        cache?.setObject(token, forKey: pushNotificationTokenKey)
    }

    func loggedIn(token: String?) {
        if let unwrappedToken = token {
            cache?.setObject(unwrappedToken, forKey: tokenKey, expires: .Never)
        }
    }

    func loggedOut() {
        cache?.removeObjectForKey(tokenKey)
        cache?.removeObjectForKey(pushNotificationsSettingsKey)
        cache?.removeObjectForKey(modeKey)
        cache?.removeObjectForKey(firstTimeInSingleModeKey)
    }

    func getAuthToken() -> String? {
        let token = getStringForKey(tokenKey)
        return token
    }

    func pushNotificationsSettingChanged(isEnabled: Bool) {
        cache?.setObject(String(isEnabled), forKey: pushNotificationsSettingsKey, expires: .Never)
    }

    func pushNotificationsSetting() -> Bool {
        guard let value = getStringForKey(pushNotificationsSettingsKey) else { return false }
        return NSString(string: value).boolValue
    }

    private func getStringForKey(key: String) -> String? {
        return cache?.objectForKey(key) as String?
    }
}
