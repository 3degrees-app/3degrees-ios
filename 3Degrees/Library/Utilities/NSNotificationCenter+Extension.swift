//
//  NSNotificationCenter+Extension.swift
//  3Degrees
//
//  Created by Gigster Developer on 10/3/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation
import ThreeDegreesClient

extension NSNotificationCenter {
    static func showSuggestedMatchWithUser(match: Match) {
        guard AppController.shared.currentUserMode.value == .Single else { return }
        let userAnyObject = match as AnyObject
        NSNotificationCenter.defaultCenter().postNotificationName("ShowSuggestedMatch",
                                                                  object: nil,
                                                                  userInfo: ["match": userAnyObject])
    }

    static func subsribeToShowSuggestedMatch(callback: (Match) -> ()) {
        guard AppController.shared.currentUserMode.value == .Single else { return }
        NSNotificationCenter.defaultCenter().addObserverForName(
            "ShowSuggestedMatch",
            object: nil,
            queue: NSOperationQueue.mainQueue()) { (notification) in
                if let match = notification.userInfo?["match"] as? Match {
                    callback(match)
                }
        }
    }
}
