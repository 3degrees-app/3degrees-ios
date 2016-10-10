//
//  TableViewMock.swift
//  3Degrees
//
//  Created by Gigster Developer on 6/2/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

@testable import _Degrees

class TableViewMock: UITableView {
    var indexPathsForReloadedRows = [NSIndexPath]()
    var reloaded: Bool = false

    override func reloadRowsAtIndexPaths(indexPaths: [NSIndexPath], withRowAnimation animation: UITableViewRowAnimation) {
        indexPathsForReloadedRows = indexPaths
    }

    override func reloadData() {
        reloaded = true
    }

    override func dequeueReusableCellWithIdentifier(identifier: String) -> UITableViewCell? {
        switch identifier {
        case R.reuseIdentifier.actionTableViewCell.identifier:
            let cell = ActionTableViewCell()
            cell.actionNameLabel = UILabel()
            return cell
        case R.reuseIdentifier.switchActionTableViewCell.identifier:
            let cell = SwitchActionTableViewCell()
            cell.actionSwitch = UISwitch()
            cell.actionNameLabel = UILabel()
            return cell
        case R.reuseIdentifier.selectActionTableViewCell.identifier:
            let cell = SelectActionTableViewCell()
            cell.actionNameLabel = UILabel()
            return cell
        default:
            return UITableViewCell()
        }
    }
}
