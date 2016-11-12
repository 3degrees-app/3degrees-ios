//
//  AppNavigator.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/17/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

protocol AppNavigator {
    var showAction: (identifier: String) -> () { get }
    var presentAction: (identifier: String) -> () { get }
    var showVcAction: (vc: UIViewController) -> () { get }
    var presentVcAction: (vc: UIViewController) -> () { get }
    var popAction: () -> () { get }
    var dismissAction: () -> () { get }
    var presentOnWindowRootVc: (vc: UIViewController) -> () { get }
    var switchTab: (tabNumber: Int) -> () { get }

    var navController: UINavigationController? { get }
}

extension AppNavigator where Self: UIViewController {
    var showAction: (identifier: String) -> () {
        return {[unowned self](identifier) in
            self.performSegueWithIdentifier(identifier, sender: self)
        }
    }

    var presentAction: (identifier: String) -> () {
        return showAction
    }

    var showVcAction: (vc: UIViewController) -> () {
        return {[unowned self] viewController in
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    var presentVcAction: (vc: UIViewController) -> () {
        return {[unowned self] (viewController) in
            self.presentViewController(viewController, animated: true, completion: nil)
        }
    }

    var popAction: () -> () {
        return {[unowned self] in
            self.navigationController?.popViewControllerAnimated(true)
        }
    }

    var dismissAction: () -> () {
        return {[unowned self] in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    var presentOnWindowRootVc: (vc: UIViewController) -> () {
        return {[unowned self] (viewController) in
            self.view.window?.rootViewController?.presentVcAction(vc: viewController)
        }
    }

    var switchTab: (tabNumber: Int) -> () {
        return {[unowned self] (tabNumber) in
            self.tabBarController?.selectedIndex = tabNumber
        }
    }

    var navController: UINavigationController? {
        return self.navigationController
    }
}


extension UIViewController: AppNavigator {}
