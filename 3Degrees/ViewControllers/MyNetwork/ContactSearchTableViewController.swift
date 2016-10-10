//
//  ContactSearchTableViewController.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/23/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import Bond

class ContactSearchTableViewController: UITableViewController, ViewProtocol {
    private lazy var viewModel: ContactSearchViewModel = {[unowned self] in
        var viewModel = ContactSearchViewModel(router: self, mode: self.mode)
        viewModel.selectionDelegate = self.selectionDelegate
        self.userType.bindTo(viewModel.userType)
        return viewModel
    }()

    var searchResultsUpdater: UISearchResultsUpdating {
        return viewModel
    }

    var mode: ContactSearchViewModel.SearchMode = .Invite
    var selectionDelegate: ContactSelectDelegate? = nil
    var userType: Observable<MyNetworkTab.UsersType> = Observable<MyNetworkTab.UsersType>(.Singles)

    override func viewDidLoad() {
        viewModel.tableView = self.tableView
        applyDefaultStyle()
        configureBindings()
    }

    func applyDefaultStyle() {
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 60
    }

    func configureBindings() {
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
    }
}
