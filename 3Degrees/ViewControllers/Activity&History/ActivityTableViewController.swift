//
//  ActivityTableViewController.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/10/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

class ActivityTableViewController: UITableViewController, ViewProtocol, RootTabBarViewControllerProtocol {

    private let backgroundEmptyLabel = UILabel()

    private lazy var viewModel: ActivityTableViewModel = {[unowned self] in
        return ActivityTableViewModel(
            tabBarController: self.tabBarController!,
            router: self,
            tableView: self.tableView
        )
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        applyDefaultStyle()
        configureBindings()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        removeBackButtonsTitle()
    }

    func applyDefaultStyle() {
        view.backgroundColor = Constants.ViewOnBackground.Color

        title = "Activity & History"
        tableView.preservesSuperviewLayoutMargins = false
        tableView.tableFooterView = UIView()
        tableView.canCancelContentTouches = true
        setUpLeftMenuButton()
    }

    func configureBindings() {
        viewModel.refreshCompletedCallback = {[weak self] in
            self?.refreshControl?.endRefreshing()
        }
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
    }

    @IBAction func refresh(sender: UIRefreshControl) {
        viewModel.reloadData()
    }
}
