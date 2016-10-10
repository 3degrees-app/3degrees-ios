//
//  ContactSearchViewModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/23/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import Bond

protocol ContactSelectDelegate {
    func selected(contact: UserInfo)
}

extension ContactSearchViewModel: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        searchText.next(searchController.searchBar.text)
    }
}

extension ContactSearchViewModel: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if mode == .Select {
            selectionDelegate?.selected(people[indexPath.row])
        }
    }
}

extension ContactSearchViewModel: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.people.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = R.reuseIdentifier.contactSearchTableViewCell.identifier
        let viewModel = ContactSearchCellViewModel(
            contact: people[indexPath.row],
            userType: userType.value,
            invitedHandler: contactWasInvited,
            mode: self.mode)
        guard let cell: ContactSearchTableViewCell =
            tableView.getCell(viewModel, cellIdentifier: cellId)
            else { return UITableViewCell() }
        return cell
    }
}


class ContactSearchViewModel: NSObject, ViewModelProtocol {
    var router: RoutingProtocol? = nil
    var myNetworkApi: MyNetworkApiProtocol = MyNetworkApiController()
    var people: [UserInfo] = []
    var tableView: UITableView? = nil
    let searchText: Observable<String?> = Observable("")
    let mode: SearchMode
    var selectionDelegate: ContactSelectDelegate? = nil
    let userType: Observable<MyNetworkTab.UsersType> = Observable<MyNetworkTab.UsersType>(.Singles)

    init(router: RoutingProtocol, mode: SearchMode) {
        self.router = router
        self.mode = mode
        super.init()
        searchText.ignoreNil()
                  .throttle(0.5, queue: Queue.Main)
                  .observeNew {[unowned self] (filter) in
                    self.loadPeople(filter)
        }
    }

    func loadPeople(filter: String) {
        removeAllPeople()
        guard !filter.isEmpty else {
            return
        }
        let singlesOnly = mode == .Select ? false : userType.value.isSingles && userType.value != .Dates
        let matchmaker = mode == .Select ?
            AppController.shared.currentUser.value?.username :
            nil
        let requestModel = UsersRequestModel(
            query: filter,
            singlesOnly: singlesOnly,
            limit: 10,
            page: 0,
            matchmaker: matchmaker,
            excludeMyConnections: mode == .Invite
        )
        myNetworkApi.getUsers(requestModel) { (users) in
            self.updateFoundPeople(users.map { $0 as UserInfo })
        }
    }

    func updateFoundPeople(newPeople: [UserInfo]) {
        tableView?.beginUpdates()
        let newPeopleIndexPaths = newPeople.enumerate()
                                           .map {(index, element) -> NSIndexPath in
                return NSIndexPath(forRow: index, inSection: 0)
        }
        self.people.insertContentsOf(newPeople, at: 0)
        tableView?.insertRowsAtIndexPaths(newPeopleIndexPaths, withRowAnimation: .Fade)
        tableView?.endUpdates()
    }

    func removeAllPeople() {
        let indexPaths = people.enumerate().map {
            NSIndexPath(forRow: $0.index, inSection: 0)
        }
        tableView?.beginUpdates()
        people.removeAll()
        tableView?.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
        tableView?.endUpdates()
    }

    func contactWasInvited(contact: UserInfo) {
        guard let indexOfContact = people.indexOf({ $0.username == contact.username })
            else { return }
        removeInvitedUser(indexOfContact)
    }

    func removeInvitedUser(index: Int) {
        guard people.count > index else { return }
        tableView?.beginUpdates()
        people.removeAtIndex(index)
        let indexPath = NSIndexPath(forRow: index, inSection: 0)
        tableView?.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        tableView?.endUpdates()
    }

    enum SearchMode {
        case Invite
        case Select
    }
}
