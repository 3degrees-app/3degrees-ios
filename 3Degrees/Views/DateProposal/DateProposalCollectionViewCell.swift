//
//  DateProposalTableViewCell.swift
//  3Degrees
//
//  Created by Gigster Developer on 9/2/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import PureLayout

class DateProposalCollectionViewCell: UICollectionViewCell, TableCellProtocol {
    typealias T = DateProposalViewModel
    var viewModel: T?
    var proposalViewController: DateProposalViewController? = nil

    func configure(cellViewModel: T) {
        self.subviews.forEach {
            $0.removeFromSuperview()
        }
        viewModel = cellViewModel

        let dateProposalScene = R.storyboard.dateProposalScene
        guard let dateProposalVc = dateProposalScene.dateProposalViewController()
            else {
            return
        }
        proposalViewController = dateProposalVc
        dateProposalVc.viewModel = viewModel
        dateProposalVc.view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dateProposalVc.view)
        dateProposalVc.view.autoPinEdgesToSuperviewEdges()
        layoutIfNeeded()
    }
}
