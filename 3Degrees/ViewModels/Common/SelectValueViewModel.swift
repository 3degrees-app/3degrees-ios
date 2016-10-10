//
//  SelectValueViewModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/7/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import Rswift

extension SelectValueViewModel: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = R.reuseIdentifier.selectValueTableViewCell.identifier
        let vm = SelectValueCellViewModel(value: values[indexPath.row])
        guard let cell: SelectValueTableViewCell = tableView.getCell(vm, cellIdentifier: cellId)
            else { return UITableViewCell() }
        return cell
    }
}

extension SelectValueViewModel: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let value = values[indexPath.row]
        router?.popAction()
        delegate.valueSelected(value)
    }
}

class SelectValueViewModel: NSObject, ViewModelProtocol {
    var router: RoutingProtocol?
    let values: [String]
    let delegate: SelectValueDelegate

    init(router: RoutingProtocol, values: [String], delegate: SelectValueDelegate) {
        self.router = router
        self.values = values
        self.delegate = delegate
    }
}
