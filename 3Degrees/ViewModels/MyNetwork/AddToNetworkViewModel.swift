//
//  AddToNetworkViewModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/13/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import Rswift
import Bond

extension AddToNetworkViewModel: UISearchControllerDelegate {
    func willPresentSearchController(searchController: UISearchController) {
        self.appNavigator?.navController?.navigationBar.translucent = true
    }

    func willDismissSearchController(searchController: UISearchController) {
        self.appNavigator?.navController?.navigationBar.translucent = false
    }
}

class AddToNetworkViewModel: NSObject, ViewModelProtocol {
    var appNavigator: AppNavigator?
    var actionTitle: String {
        return "Add New \(postfix)"
    }

    var postfix: String {
        return userType.value == .Dates ?
               MyNetworkTab.UsersType.Matchmakers.postfix :
               userType.value.postfix
    }

    let userType: Observable<MyNetworkTab.UsersType> = Observable(.Matchmakers)

    lazy var searchResultViewController: ContactSearchTableViewController? = {[unowned self] in
        let storyboard = R.storyboard.myNetworkScene
        guard let viewController = storyboard.contactSearchTableViewController()
            else { return nil }
        self.userType.bindTo(viewController.userType)
        return viewController
    }()

    lazy var searchController: UISearchController? = {[unowned self] in
        guard let resultViewController = self.searchResultViewController else { return nil }
        let searchController = UISearchController(searchResultsController: resultViewController)
        searchController.searchResultsUpdater = resultViewController.searchResultsUpdater
        searchController.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        return searchController
    }()

    init(appNavigator: AppNavigator?) {
        self.appNavigator = appNavigator
    }

    func tapped() {
        guard let searchController = searchController
            else { return }
        appNavigator?.presentOnWindowRootVc(vc: searchController)
    }
}
