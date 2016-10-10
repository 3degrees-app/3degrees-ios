//
//  DateProposalViewController.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/8/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class DateProposalsCollectionViewController: UICollectionViewController {

    private lazy var viewModel: DateProposalsCollectionViewModel = {[unowned self] in
        let unwrappedCollectionView = self.collectionView ?? UICollectionView()
        return DateProposalsCollectionViewModel(collectionView: unwrappedCollectionView,
                                                router: self)
    }()

    override func viewDidLoad() {
        applyDefaultStyle()
        configureBindings()
        setDefaultValues()
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configureCollectionLayout()
        viewModel.viewWillAppear()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        removeBackButtonsTitle()
        viewModel.prepareForSegue(segue)
    }

    func configureCollectionLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = collectionView?.frame.size ?? CGSize()
        flowLayout.scrollDirection = .Horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        collectionView?.pagingEnabled = true
        collectionView?.setCollectionViewLayout(flowLayout, animated: true)
    }

    private func setDefaultValues() {
        title = R.string.localizable.dateProposalTitle()
    }
}

extension DateProposalsCollectionViewController: RootTabBarViewControllerProtocol {}

extension DateProposalsCollectionViewController: ViewProtocol {
    func applyDefaultStyle() {
        collectionView?.backgroundColor = Constants.ViewOnBackground.Color
    }

    func configureBindings() {
        setUpLeftMenuButton()
        let _ = viewModel
    }
}
