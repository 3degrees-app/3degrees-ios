//
//  SelectValueTableViewController.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/7/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

protocol SelectValueDelegate {
    func valueSelected(value: String)
}

class SelectValueTableViewController: UITableViewController, ViewProtocol {
    private lazy var viewModel: SelectValueViewModel = {[unowned self] in
        let backAction = {[unowned self] () in
            self.navigationController?.popViewControllerAnimated(true)
            return
        }
        return SelectValueViewModel(router: self, values: self.values, delegate: self.delegate!)
    }()

    var values: [String] = []
    var delegate: SelectValueDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        applyDefaultStyle()
        configureBindings()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    func applyDefaultStyle() {
        self.tableView.backgroundColor = Constants.ViewOnBackground.Color

        self.tableView.preservesSuperviewLayoutMargins = false
        self.tableView.separatorColor = Constants.SelectValue.SeparatorColor
    }

    func configureBindings() {
        self.tableView.dataSource = viewModel
        self.tableView.delegate = viewModel
    }
}
