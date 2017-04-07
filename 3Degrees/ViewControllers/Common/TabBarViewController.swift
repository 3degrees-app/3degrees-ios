//
//  TabBarViewController.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/5/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

protocol PersonForMatchingSelected: class {
    func selectSingleForMatching(single: UserInfo)
    func selectMatchmakerForMatching(matchmaker: UserInfo)
}

extension TabBarViewController: PersonForMatchingSelected {
    func selectSingleForMatching(single: UserInfo) {
        selectedIndex = 1
        matchingDelegate?.selectSingleForMatching(single)
    }

    func selectMatchmakerForMatching(matchmaker: UserInfo) {
        selectedIndex = 1
        matchingDelegate?.selectMatchmakerForMatching(matchmaker)
    }
}

class TabBarViewController: UITabBarController, ViewProtocol {
    weak var matchingDelegate: PersonForMatchingSelected? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        applyDefaultStyle()
        selectedIndex = 1
        delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configureBindings()
    }

    func applyDefaultStyle() {
        if let tabBarBackImage = UIImage(named: Constants.TabBar.BackgroundImage) {
            tabBar.barTintColor = UIColor(patternImage: tabBarBackImage)
        }
        tabBar.shadowImage = UIImage()
        tabBar.tintColor = Constants.TabBar.ImageTintColor
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func configureBindings() {
    }

    func setUpContent(mode: Mode) {
        let viewController: UIViewController?
        switch mode {
        case .Single:
            viewController = R.storyboard.dateProposalScene.initialViewController()
            break
        case .Matchmaker:
            viewController = R.storyboard.commonScene.pairUpNavViewController()
            break
        }
        var viewControllers = [UIViewController]()
        guard let firstVc = self.viewControllers?.first else { return }
        viewControllers.append(firstVc)
        guard let vc = viewController else { return }
        viewControllers.append(vc)
        guard let lastVc = self.viewControllers?.last else { return }
        viewControllers.append(lastVc)
        self.viewControllers = viewControllers

        guard let secondItem = self.tabBar.items?[1] else { return }
        secondItem.image = UIImage(named: "dateProposal")
        secondItem.selectedImage = UIImage(named: "dateProposalSelected")
        secondItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        secondItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 20)
    }

    func selectActivityFeedTab() {
        selectedIndex = 2
    }
}

extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(tabBarController: UITabBarController,
                          didSelectViewController viewController: UIViewController) {
        (viewControllers?.filter {
            $0 == viewController
        }.first as? UINavigationController)?.popToRootViewControllerAnimated(true)
    }
}
