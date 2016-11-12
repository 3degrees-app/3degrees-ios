//
//  RouterMock.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/26/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

@testable import _Degrees

class RouterMock: AppNavigator {
    var poped: Bool
    var dismissed: Bool
    var presentedViewController: Bool
    var showedVcWithId: String? = ""
    var tabSwitchedToIndex: Int? = nil
    
    var showAction: (identifier: String) -> () {
        return { (id) in
            self.showedVcWithId = id
        }
    }
    var presentAction: (identifier: String) -> () {
        get {
            return showAction
        }
    }
    var showVcAction: (vc: UIViewController) -> () = {(vc) in }
    var presentVcAction: (vc: UIViewController) -> () {
        get {
            return { (vc) in
                self.presentedViewController = true
            }
        }
    }
    var popAction: () -> () {
        get {
            return { self.poped = !self.poped }
        }
    }
    var dismissAction: () -> () {
        get {
            return { self.dismissed = !self.dismissed }
        }
    }

    var presentOnWindowRootVc: (vc: UIViewController) -> () {
        get {
            return { vc in self.presentedViewController = true }
        }
    }

    var switchTab: (tabNumber: Int) -> () {
        return {[unowned self] (tabNumber) in
            self.tabSwitchedToIndex = tabNumber
        }
    }
    
    var navController: UINavigationController? = UINavigationController()
    
    init() {
        poped = false
        dismissed = false
        presentedViewController = false
    }
}