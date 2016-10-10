//
//  NSNotificationCenter+Extension.swift
//  3Degrees
//
//  Created by Gigster Developer on 10/3/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation

extension NSNotificationCenter {
    static func showSuggestedMathWithUser(user: UserInfo) {
        guard AppController.shared.currentUserMode.value == .Single else { return }
        guard let userAnyObject = user as? AnyObject else { return }
        NSNotificationCenter.defaultCenter().postNotificationName("ShowSuggestedMatch",
                                                                  object: nil,
                                                                  userInfo: ["user": userAnyObject])
    }

    static func subsribeToShowSuggestedMath(callback: (UserInfo) -> ()) {
        guard AppController.shared.currentUserMode.value == .Single else { return }
        NSNotificationCenter.defaultCenter().addObserverForName(
            "ShowSuggestedMatch",
            object: nil,
            queue: NSOperationQueue.mainQueue()) { (notification) in
                if let user = notification.userInfo?["user"] as? UserInfo {
                    callback(user)
                }
        }
    }
}
