//
//  EnterForegroundNotificationProtocol.swift
//  3Degrees
//
//  Created by Pavel Sipaylo on 10/21/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

protocol EnterForegroundNotificationProtocol: class {
    var enterForegroundCallback: (() -> ())? { get set }
    var appWillEnterForegroundObserver: NSObjectProtocol? { get set }

    func subscribeToForegroundNotification()
    func unsubscribeFromForegroundNotification()
}

extension EnterForegroundNotificationProtocol where Self: UIViewController {
    func subscribeToForegroundNotification() {
        appWillEnterForegroundObserver = NSNotificationCenter.defaultCenter().addObserverForName(
            UIApplicationWillEnterForegroundNotification,
            object: nil,
            queue: NSOperationQueue.mainQueue()) {[weak self] notification in
                self?.enterForegroundCallback?()
        }
    }

    func unsubscribeFromForegroundNotification() {
        guard let observer = appWillEnterForegroundObserver else { return }
        NSNotificationCenter
            .defaultCenter()
            .removeObserver(
                observer,
                name: UIApplicationWillEnterForegroundNotification,
                object: nil)
    }
}
