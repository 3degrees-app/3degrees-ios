//
//  MatchmakerTableViewCell.swift
//  3Degrees
//
//  Created by Gigster Developer on 7/26/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import Bond

class MatchmakerTableViewCell: UITableViewCell, TableCellProtocol {
    typealias T = MatchmakersViewModel
    @IBOutlet weak var matchmakersCollectionView: MatchmakersCollectionView!

    @IBOutlet weak var pageControl: UIPageControl!
    var viewModel: T?

    func configure(cellViewModel: T) {
        viewModel = cellViewModel

        matchmakersCollectionView.applyDefaultStyle()
        viewModel?.selectedMatchmakerIndex.observe {[unowned self] in
            self.pageControl.currentPage = $0
        }
        if let vm = viewModel {
            let count = vm.matchmakers.count
            self.pageControl.numberOfPages = count
        }

        matchmakersCollectionView.delegate = viewModel
        matchmakersCollectionView.dataSource = viewModel
    }
}
