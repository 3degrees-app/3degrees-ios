//
//  DateProposalsCollectionViewModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 9/2/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import SwiftPaginator
import DZNEmptyDataSet
import SwiftMoment

import ThreeDegreesClient

class DateProposalsCollectionViewModel: NSObject, ViewModelProtocol {
    var api: DateProposalApiProtocol = DateProposalApiController()
    var appNavigator: AppNavigator? = nil
    var users: [UserInfo] = []
    var collectionView: UICollectionView
    var paginator: Paginator<UserInfo>? = nil

    init(collectionView: UICollectionView, appNavigator: AppNavigator?) {
        self.appNavigator = appNavigator
        self.collectionView = collectionView
        super.init()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.emptyDataSetSource = self
        self.collectionView.emptyDataSetDelegate = self
        paginator = Paginator(pageSize: 40,
                              fetchHandler: fetchProposals,
                              resultsHandler: handleNewPageLoadResults,
                              resetHandler: paginatorResetHandler)

        NSNotificationCenter.subsribeToShowSuggestedMath {[weak self] (user) in
            guard let userIndex = self?.users.indexOf({ $0.username == user.username }) else {
                let ip = NSIndexPath(forItem: self?.users.count ?? 0, inSection: 0)
                self?.users.append(user)
                self?.collectionView.insertItemsAtIndexPaths([ip])
                self?.collectionView.scrollToItemAtIndexPath(
                    ip,
                    atScrollPosition: .CenteredHorizontally,
                    animated: true)
                return
            }
            let ip = NSIndexPath(forItem: userIndex, inSection: 0)
            self?.collectionView.scrollToItemAtIndexPath(
                ip,
                atScrollPosition: .CenteredHorizontally,
                animated: true
            )
        }
    }

    func viewWillAppear() {
        paginator?.fetchFirstPage()
    }

    func fetchProposals(paginator: Paginator<UserInfo>, page: Int, pageSize: Int) {
        api.getDatesProposals(pageSize, page: page - 1) {(users) in
            paginator.receivedResults(users.map { $0 as UserInfo }, total: users.count)
        }
    }

    func handleNewPageLoadResults(paginator: Paginator<UserInfo>, users: [UserInfo]) {
        users.forEach {[unowned self] (user) in
            let indexPath = NSIndexPath(forItem: self.users.count, inSection: 0)
            self.users.append(user)
            self.collectionView.insertItemsAtIndexPaths([indexPath])
            self.collectionView.reloadEmptyDataSet()
        }
    }

    func paginatorResetHandler(paginator: Paginator<UserInfo>) {
        users = []
        collectionView.reloadSections(NSIndexSet(index: 0))
    }

    func prepareForSegue(segue: UIStoryboardSegue) {
        if let viewController = segue.destinationViewController as? ScheduleResultsViewController {
            guard let index = collectionView.indexPathsForVisibleItems().first?.item else { return }
            viewController.user = users[index]
        }
    }
}

extension DateProposalsCollectionViewModel: DZNEmptyDataSetSource,
                                            DZNEmptyDataSetDelegate {
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [
            NSFontAttributeName: Constants.Fonts.DefaultThin,
            NSForegroundColorAttributeName: UIColor.blackColor()
        ]

        let attributedString = NSAttributedString(
            string: R.string.localizable.emptyDateProposalsMessage(),
            attributes: attributes)
        return attributedString
    }

    func emptyDataSetShouldFadeIn(scrollView: UIScrollView!) -> Bool {
        return true
    }

    func emptyDataSetShouldDisplay(scrollView: UIScrollView!) -> Bool {
        return users.isEmpty
    }
}

extension DateProposalsCollectionViewModel: UICollectionViewDelegate,
                                            UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return users.count
    }

    func collectionView(collectionView: UICollectionView,
                        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellId = R.reuseIdentifier.dateProposalCell
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            cellId,
            forIndexPath: indexPath) else {
            return UICollectionViewCell()
        }
        let viewModel = DateProposalViewModel(appNavigator: appNavigator,
                                              user: users[indexPath.row])
        viewModel.delegate = self
        cell.configure(viewModel)
        return cell
    }

    func collectionView(collectionView: UICollectionView,
                        willDisplayCell cell: UICollectionViewCell,
                        forItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.item == users.count - 2 {
            paginator?.fetchNextPage()
        }
    }
}

extension DateProposalsCollectionViewModel: DateProposalRefreshDelegate {
    func actionWasTaken(user: UserInfo) {
        let i = users.indexOf { $0.username == user.username }
        guard let index = i else { return }
        users.removeAtIndex(index)
        collectionView.deleteItemsAtIndexPaths([NSIndexPath(forItem: index, inSection: 0)])
        collectionView.reloadEmptyDataSet()
    }
}
