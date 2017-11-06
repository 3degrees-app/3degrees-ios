//
//  PairUpViewModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/20/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import Bond
import DZNEmptyDataSet
import SwiftPaginator
import ThreeDegreesClient

extension PairUpViewModel: DZNEmptyDataSetSource {
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [
            NSFontAttributeName: Constants.Fonts.DefaultThin,
            NSForegroundColorAttributeName: UIColor.blackColor()
        ]

        let attributedString = NSAttributedString(
            string: R.string.localizable.emptyPairUpScreenMessage(),
            attributes: attributes)
        return attributedString
    }
}

extension PairUpViewModel: DZNEmptyDataSetDelegate {
    func emptyDataSetShouldFadeIn(scrollView: UIScrollView!) -> Bool {
        return true
    }

    func emptyDataSetShouldDisplay(scrollView: UIScrollView!) -> Bool {
        return isEmptyMySingles()
    }
}

extension PairUpViewModel: UITableViewDelegate {
    func tableView(tableView: UITableView,
                   estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 401
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let row = indexPath.row
        switch row {
        case 0:
            return 401
        case 2:
            guard proposedPerson?.placeOfWork.isEmpty == true &&
                  proposedPerson?.title.isEmpty == true else { break }
            return 0
        case 3:
            guard proposedPerson?.school.isEmpty == true &&
                  proposedPerson?.degree.isEmpty == true else { break }
            return 0
        case 4:
            guard proposedPerson?.biography.isEmpty == true else { break }
            return 0
        case 5:
            guard proposedPerson?.heightString.isEmpty == true else { break }
            return 0
        default:
            break
        }
        if proposedPerson == nil {
            return 0
        }
        return UITableViewAutomaticDimension
    }
}

extension PairUpViewModel: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isEmptyMySingles() ? 0 : 6
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return superTableViewDataSource.tableView(tableView,
                                                  cellForRowAtIndexPath: indexPath)
    }
}

extension PairUpViewModel: ProposedPeopleDelegate {
    func personDisplayed(user: UserInfo, mode: ProposedPeopleCollectionViewModel.Own) {
        switch mode {
        case .Alian:
            updateInfo(user)
            markAsSeen()
            break
        default:
            self.myPerson = user
            proposedPeoplePaginator?.fetchFirstPage()
            break
        }
    }

    func loadMore(type: ProposedPeopleCollectionViewModel.Own) {
        switch type {
        case .Alian:
            proposedPeoplePaginator?.fetchNextPage()
        default:
            myPeoplePaginator?.fetchNextPage()
        }
    }

    func markAsSeen() {
        guard let my = myPerson, proposed = proposedPerson else { return }
        guard let myUsername = my.username, proposedUsername = proposed.username else { return }
        api.markMatchAsViewed(myUsername, matchUsername: proposedUsername) { }
    }
}

extension PairUpViewModel: PersonForMatchingSelected {
    func selectMatchmakerForMatching(matchmaker: UserInfo) {
        filterModel = FilterModel(matchmaker: matchmaker,
                                  ageFrom: nil,
                                  ageTo: nil,
                                  gender: nil)
        proposedPeoplePaginator?.fetchFirstPage()
    }

    func selectSingleForMatching(single: UserInfo) {
        mySinglesViewModel.showUser(single)
    }
}

extension PairUpViewModel: FilteringProtocol {
    func filtersSelected(filter: FilterModel) {
        filterModel = filter
        proposedPeoplePaginator?.fetchFirstPage()
    }
}

extension PairUpViewModel {
    func fetchMySingles(paginator: Paginator<UserInfo>, page: Int, pageSize: Int) {
        api.getSingles(page - 1, limit: pageSize) {[unowned self] (users) in
            self.myPeoplePaginator?.receivedResults(users.map { $0 as UserInfo },
                                      total: users.count)
        }
    }

    func mySinglesResultsHandler(paginator: Paginator<UserInfo>, results: [UserInfo]) {
        mySinglesViewModel.loadNewData(results)
        tableView.reloadData()
    }

    func mySinglesResetHandler(paginator: Paginator<UserInfo>) {
        mySinglesViewModel.reset()
    }

    func fetchProposed(paginator: Paginator<UserInfo>, page: Int, pageSize: Int) {
        guard let myPersonUsername = myPerson?.username else { return }
        let request = PotentialMatchesRequestModel(
            username: myPersonUsername,
            page: page - 1,
            limit: pageSize,
            ageFrom: filterModel?.ageFrom,
            ageTo: filterModel?.ageTo,
            gender: filterModel?.gender,
            matchmakerUsername: filterModel?.matchmaker?.username) {[unowned self] (users) in
                self.proposedPeoplePaginator?.receivedResults(users.map { $0 as UserInfo },
                                                              total: users.count)
        }
        api.getPotentialMatches(request)
    }

    func proposedResultsHandler(paginator: Paginator<UserInfo>, results: [UserInfo]) {
        proposedSinglesViewModel.loadNewData(results)
        if isEmptyProposals() {
            if isFirstLoad {
                if let my = myPerson {
                    self.mySinglesViewModel.nextAfter(my)
                } else {
                    updateInfo(nil)
                }
            } else {
                updateInfo(nil)
            }
        } else {
            isFirstLoad = false
        }
    }

    func proposedResetHandler(paginator: Paginator<UserInfo>) {
        proposedSinglesViewModel.reset()
    }
}

class PairUpViewModel: NSObject, ViewModelProtocol {
    var api: PairUpApiProtocol = PairUpApiController()
    var appNavigator: AppNavigator?
    let tableView: UITableView
    let superTableViewDataSource: UITableViewDataSource

    let mySinglesViewModel: ProposedPeopleCollectionViewModel
    let proposedSinglesViewModel: ProposedPeopleCollectionViewModel

    let pairUpButton: Observable<String?>
    let pairUpButtonHidden: Observable<Bool>
    let matchmakerName: Observable<String?>
    let whoseMatchmaker: Observable<String?>
    let placeOfWork: Observable<String?>
    let jobTitle: Observable<String?>
    let degree: Observable<String?>
    let school: Observable<String?>
    let bio: Observable<String?>
    let height: Observable<String?>

    private var myPerson: UserInfo? = nil
    private var proposedPerson: UserInfo? = nil

    var myPeoplePaginator: Paginator<UserInfo>? = nil
    var proposedPeoplePaginator: Paginator<UserInfo>? = nil

    var filterModel: FilterModel? = nil
    private var isFirstLoad = true

    init(appNavigator: AppNavigator, tableView: UITableView, superTableViewDataSource: UITableViewDataSource) {
        self.appNavigator = appNavigator
        self.tableView = tableView
        self.superTableViewDataSource = superTableViewDataSource
        pairUpButton = Observable("Pair Up")
        pairUpButtonHidden = Observable(false)
        matchmakerName = Observable(nil)
        whoseMatchmaker = Observable(nil)
        placeOfWork = Observable(nil)
        jobTitle = Observable(nil)
        degree = Observable(nil)
        school = Observable(nil)
        bio = Observable(nil)
        height = Observable(nil)
        mySinglesViewModel = ProposedPeopleCollectionViewModel(appNavigator: appNavigator, type: .Mine)
        proposedSinglesViewModel = ProposedPeopleCollectionViewModel(appNavigator: appNavigator, type: .Alian)
        super.init()
        mySinglesViewModel.delegate = self
        proposedSinglesViewModel.delegate = self

        myPeoplePaginator = Paginator(pageSize: 40,
                                      fetchHandler: self.fetchMySingles,
                                      resultsHandler: self.mySinglesResultsHandler,
                                      resetHandler: self.mySinglesResetHandler)
        proposedPeoplePaginator = Paginator(pageSize: 40,
                                            fetchHandler: self.fetchProposed,
                                            resultsHandler: self.proposedResultsHandler,
                                            resetHandler: self.proposedResetHandler)
        myPeoplePaginator?.fetchFirstPage()
    }

    func updateInfo(user: UserInfo?) {
        proposedPerson = user
        pairUpButtonHidden.next(user == nil)
        matchmakerName.next(user?.matchmakerInfo ?? nil)
        if let name = user?.firstName {
            whoseMatchmaker.next("\(name.capitalizedString)'s Matchmaker")
        } else {
            whoseMatchmaker.next("")
        }
        placeOfWork.next(user?.placeOfWork ?? "")
        jobTitle.next(user?.title ?? "")
        degree.next(user?.degree ?? "")
        school.next(user?.school ?? "")
        bio.next(user?.biography ?? "")
        height.next(user?.heightString ?? "")
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    func handlePairUpRequest() {
        guard let my = myPerson, proposed = proposedPerson else { return }
        guard let mySingleUsername = my.username,
                  proposedSingleUsername = proposed.username else { return }

        api.pairUp(mySingleUsername, matchUsername: proposedSingleUsername) {[weak self] in
            self?.pairUpButton.next("Match Sent")
            Observable("Pair Up").throttle(1.0, queue: .Main).observe { val in
                self?.proposedSinglesViewModel.removePerson(proposed)
                self?.mySinglesViewModel.nextAfter(my) // Scroll to the matchmaker's next single, which will reload the bottom list
                self?.checkIfNoAvailablePairs()
                self?.pairUpButton.next(val)
            }
        }
    }

    func openFiltersPage() {
        self.appNavigator?.showAction(
            identifier: R.segue.pairUpViewController.toFilters.identifier
        )
    }

    func checkIfNoAvailablePairs() {
        if isEmptyProposals() && isEmptyMySingles() {
            let indexPaths = (0...4).map {NSIndexPath(forRow: $0, inSection: 0)}
            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
            tableView.endUpdates()
        } else if isEmptyProposals() {
            if let my = myPerson {
                self.mySinglesViewModel.nextAfter(my)
            } else {
                updateInfo(nil)
            }
        }
    }

    func isEmptyProposals() -> Bool {
        return proposedSinglesViewModel.isEmpty()
    }

    func isEmptyMySingles() -> Bool {
        return mySinglesViewModel.isEmpty()
    }

    func prepareForSegue(segue: UIStoryboardSegue) {
        let identifier = R.segue.pairUpViewController.toFilters.identifier
        if segue.identifier == identifier {
            guard let viewController = segue.destinationViewController as? FilterViewController else {
                return
            }
            viewController.delegate = self
            viewController.prevFilter = filterModel
        }
    }
}
