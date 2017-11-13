//
//  DateProposalsCollectionViewModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 9/2/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Bond
import UIKit
import SwiftPaginator
import DZNEmptyDataSet
import SwiftMoment

import ThreeDegreesClient

class DateProposalsCollectionViewModel: NSObject, ViewModelProtocol {
    var api: DateProposalApiProtocol = DateProposalApiController()
    var myNetworkapi: MyNetworkApiProtocol = MyNetworkApiController()
    var appNavigator: AppNavigator? = nil
    var matches: [Match] = []
    var collectionView: UICollectionView
    var paginator: Paginator<Match>? = nil
    private var myMatchmakers: Observable<[UserInfo]> = Observable([])

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

        NSNotificationCenter.subsribeToShowSuggestedMatch {[weak self] (user) in
            guard let userIndex = self?.matches.indexOf({ $0.user!.username == user.username }) else {
                let ip = NSIndexPath(forItem: self?.matches.count ?? 0, inSection: 0)
                //self?.users.append(user)
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

        myNetworkapi.getMatchmakers(0, limit: 1000, completion: { [unowned self] matchmakers in
            self.myMatchmakers.next(matchmakers.map({$0}))
        })
    }

    func viewWillAppear() {
        paginator?.fetchFirstPage()
    }

    func fetchProposals(paginator: Paginator<Match>, page: Int, pageSize: Int) {
        api.getDatesProposals(pageSize, page: page - 1) {(users) in
            paginator.receivedResults(users, total: users.count)
        }
    }

    func handleNewPageLoadResults(paginator: Paginator<Match>, matches: [Match]) {
        matches.forEach {[unowned self] (match) in
            let indexPath = NSIndexPath(forItem: self.matches.count, inSection: 0)
            self.matches.append(match)
            self.collectionView.insertItemsAtIndexPaths([indexPath])
            self.collectionView.reloadEmptyDataSet()
        }
    }

    func paginatorResetHandler(paginator: Paginator<Match>) {
        matches = []
        collectionView.reloadSections(NSIndexSet(index: 0))
    }

    func prepareForSegue(segue: UIStoryboardSegue) {
        if let viewController = segue.destinationViewController as? ScheduleResultsViewController {
            guard let index = collectionView.indexPathsForVisibleItems().first?.item else { return }
            viewController.user = matches[index].user!
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
        return matches.isEmpty
    }
}

extension DateProposalsCollectionViewModel: UICollectionViewDelegate,
                                            UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return matches.count
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
                                              match: matches[indexPath.row],
                                              myMatchmakers: myMatchmakers)
        viewModel.delegate = self
        cell.configure(viewModel)
        return cell
    }

    func collectionView(collectionView: UICollectionView,
                        willDisplayCell cell: UICollectionViewCell,
                        forItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.item == matches.count - 2 {
            paginator?.fetchNextPage()
        }
    }
}

extension DateProposalsCollectionViewModel: DateProposalRefreshDelegate {
    func actionWasTaken(user: UserInfo) {
        let i = matches.indexOf { $0.user!.username == user.username }
        guard let index = i else { return }
        matches.removeAtIndex(index)
        collectionView.deleteItemsAtIndexPaths([NSIndexPath(forItem: index, inSection: 0)])
        collectionView.reloadEmptyDataSet()
    }
}
