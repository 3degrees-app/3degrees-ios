//
//  FullScreenViewModelProtocol.swift
//  3Degrees
//
//  Created by Ryan Martin on 4/26/17.
//  Copyright © 2017 Gigster. All rights reserved.
//

import Foundation
import UIKit

protocol FullScreenViewModelProtocol: ViewModelProtocol {
}

extension FullScreenViewModelProtocol {
    func show(viewController: UIViewController, withMenu: Bool) {
        if (withMenu) {
            guard let tabBar = AppController.shared.leftMenu?.mainView as? TabBarViewController
            else { return }
            if let index = tabBar.viewControllers?.indexOf(viewController) {
                tabBar.selectedIndex = index
            } else {
                guard let item = tabBar.viewControllers?[tabBar.selectedIndex] else { return }
                guard let tabViewController = item.childViewControllers.first else { return }
                tabViewController.showVcAction(vc: viewController)
            }
        } else {
            guard let appDelegate = UIApplication.sharedApplication().delegate else { return }
            guard let w = appDelegate.window else { return }
            w?.rootViewController = viewController
        }
    }
}