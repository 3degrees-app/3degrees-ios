//
//  UITableView+GetCell.swift
//  3Degrees
//
//  Created by Gigster Developer on 6/1/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

extension UITableView {
    func getCell<CellType: TableCellProtocol, CellViewModel: ViewModelProtocol> (
        viewModel: CellViewModel,
        cellIdentifier: String) -> CellType? {
        guard let typelessCell = self.dequeueReusableCellWithIdentifier(cellIdentifier)
            else { return nil }
        guard let cell = typelessCell as? CellType else { return nil }
        guard let vm = viewModel as? CellType.T else { return nil }
        cell.configure(vm)
        return cell
    }
}
