//
//  ProposedPeopleCollectionView.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/20/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class ProposedPeopleCollectionView: UICollectionView, ViewProtocol {
    private weak var viewModel: ProposedPeopleCollectionViewModel? = nil
    let sizeOfItem = CGSize(width: 290, height: 200)

    func configure(viewModel: ProposedPeopleCollectionViewModel) {
        self.viewModel = viewModel
        viewModel.collectionView = self
        emptyDataSetSource = viewModel
        emptyDataSetDelegate = viewModel
        applyDefaultStyle()
        configureBindings()
    }

    func applyDefaultStyle() {
        backgroundColor = UIColor.clearColor()
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .Horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 2
        flowLayout.itemSize = sizeOfItem
        pagingEnabled = true
        collectionViewLayout = flowLayout
    }

    func configureBindings() {
        self.dataSource = viewModel
        self.delegate = viewModel
    }
}
