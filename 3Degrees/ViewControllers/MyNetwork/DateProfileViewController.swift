//
//  DateProfileViewController.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/17/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

class DateProfileViewController: UITableViewController, ViewProtocol {
    private lazy var viewModel: DateProfileViewModel = {[unowned self] in
        let viewModel = DateProfileViewModel(
            user: self.user,
            selectedTab: self.selectedTab,
            tableView: self.tableView,
            appNavigator: self
        )
        if let tabBarController = self.tabBarController as? TabBarViewController {
            viewModel.matchingDelegate = tabBarController
        }
        return viewModel
    }()

    var user: UserInfo!
    var selectedTab: MyNetworkTab!

    override func viewDidLoad() {
        applyDefaultStyle()
        configureBindings()

        title = user.fullName
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        viewModel.prepareForSegue(segue)
    }

    func applyDefaultStyle() {
        tableView.backgroundColor = Constants.ViewOnBackground.Color
        tableView.preservesSuperviewLayoutMargins = false
        tableView.separatorColor = Constants.Profile.TableBordersColor
        tableView.tableFooterView = UIView()
    }

    func configureBindings() {
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
    }
}
