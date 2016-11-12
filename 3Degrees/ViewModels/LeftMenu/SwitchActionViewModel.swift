//
//  SwitchActionViewModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/7/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

protocol SwitchActionViewModelProtocol {
    var actionName: String { get }
    init(action: AccountAction)
    func switchValueChanged(isOn: Bool)
}

struct SwitchActionViewModel: ViewModelProtocol {
    var appNavigator: AppNavigator? = nil
    let action: AccountAction
    var userApi: UserApiProtocol = UserApiController()

    init(action: AccountAction) {
        self.action = action
    }

    var actionName: String {
        return action.rawValue
    }

    var switchValue: Bool {
        switch action {
        case .PushNotifications:
            return AppController.shared.cacheController.pushNotificationsSetting()
        case .OpenToDate:
            let firstTimeInSingle = AppController.shared.cacheController.firstTimeInSingleMode
            let isSingleMode = AppController.shared.cacheController.lastMode == .Single
            if firstTimeInSingle && isSingleMode {
                AppController.shared.currentUser.value?.isSingle = true
                AppController.shared.cacheController.setFirstTimeInSingleMode(false)
                userApi.switchIsSingle(true) {}
            }
            guard let isSingle = AppController.shared.currentUser.value?.isSingle
                else { return false }
            return isSingle
        default:
            return false
        }
    }

    func switchValueChanged(isOn: Bool) {
        switch action {
        case .PushNotifications:
            // Enable push notifications
            if isOn {
                AppController.shared.registerForRemoteNotifications()
                guard let token = AppController.shared.cacheController.pushNotificationToken else { break }
                userApi.switchPushNotifications(token, value: true) {
                    AppController.shared.cacheController.pushNotificationsSettingChanged(true)
                }
            } else {
                AppController.shared.unregisterForRemoteNotifications()
            }
            break
        case .OpenToDate:
            userApi.switchIsSingle(isOn) { }
            break
        default:
            break
        }
    }
}
