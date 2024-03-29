//
//  MatchmakersViewModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 7/26/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import Bond

extension MatchmakersViewModel: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return matchmakers.count
    }

    func collectionView(collectionView: UICollectionView,
                        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellId = R.reuseIdentifier.matchmakerCollectionViewCell.identifier
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            cellId,
            forIndexPath: indexPath
            ) as? MatchmakerCollectionViewCell
            else { return UICollectionViewCell() }
        let matchmaker = matchmakers[indexPath.item]
        let viewModel = MatchmakerCellViewModel(matchmaker: matchmaker, appNavigator: appNavigator)
        cell.configure(viewModel)
        return cell
    }
}

extension MatchmakersViewModel: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView,
                        didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedMatchmakerIndex.next(indexPath.item)
        let identifier = R.segue.dateProfileViewController.toChatWithMatchmaker.identifier
        appNavigator?.showAction(identifier: identifier)
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let itemWidth = scrollView.frame.size.width
        selectedMatchmakerIndex.next(Int(scrollView.contentOffset.x / itemWidth))
    }
}

class MatchmakersViewModel: NSObject, ViewModelProtocol {
    var appNavigator: AppNavigator? = nil
    let matchmakers: [UserInfo]
    var selectedMatchmakerIndex: Observable<Int> = Observable(0)

    init(matchmakers: [UserInfo], appNavigator: AppNavigator?) {
        self.matchmakers = matchmakers
        self.appNavigator = appNavigator
    }

    func getCurrentSelectedMatchmaker() -> UserInfo {
        return matchmakers[selectedMatchmakerIndex.value]
    }
}
