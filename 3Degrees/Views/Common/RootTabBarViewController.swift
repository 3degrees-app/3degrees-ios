//
//  RootTabBarViewControllerProtocol.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/9/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

protocol RootTabBarViewControllerProtocol {
    func setUpLeftMenuButton() -> UIBarButtonItem
}

extension RootTabBarViewControllerProtocol where Self: UIViewController {
    func setUpLeftMenuButton() -> UIBarButtonItem {
        let leftBarButton = getLeftButton()
        self.navigationItem.setLeftBarButtonItem(leftBarButton, animated: true)
        return leftBarButton
    }

    private func getLeftButton() -> UIBarButtonItem {
        let buttonFrame = CGRect(x: 0, y: 0, width: 35, height: 35)
        let leftButton = UIButton(frame: buttonFrame)
        let leftButtonImage = UIImage(named: Constants.TabBar.AccountButtonImage)
        leftButton.setImage(leftButtonImage, forState: .Normal)
        leftButton.bnd_tap.observe { () in
            AppController.shared.leftMenu?.toggle("right")
        }
        let leftBarButton = UIBarButtonItem(customView: leftButton)
        return leftBarButton
    }
}
