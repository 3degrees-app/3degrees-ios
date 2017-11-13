//
//  MyNetworkViewModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/13/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import Bond

extension MyNetworkViewModel: UITableViewDelegate {
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let typelessCell = tableView.dequeueReusableCellWithIdentifier("AddToMyNetworkCell")
            else { return UITableViewCell() }
        guard let cell = typelessCell as? AddToNetworkTableViewCell else { return typelessCell }
        cell.configure(addToNetworkViewModel)
        return cell.contentView
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedRow = indexPath.row
        self.appNavigator?.showAction(identifier: R.segue.myNetworkViewController.toProfile.identifier)
    }
}

extension MyNetworkViewModel: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let viewModel = getContactViewModel(tableView, forIndexPath: indexPath)
        let cellId = R.reuseIdentifier.contactTableViewCell.identifier

        guard let cell: ContactTableViewCell = tableView.getCell(viewModel, cellIdentifier: cellId)
            else { return UITableViewCell() }

        cell.configure(viewModel)
        return cell
    }

    private func getContactViewModel(
        tableView: UITableView,
        forIndexPath indexPath: NSIndexPath) -> ContactViewModel {
        let contact = contacts[indexPath.row]
        let viewModel = ContactViewModel(contact: contact,
                                         userType: selectedTab.value.tabKind)
        return viewModel
    }

    func tableView(tableView: UITableView,
                   editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        var actions: [UITableViewRowAction] = []
        let chatAction = UITableViewRowAction(style: .Normal, title: "Chat") {
            [unowned self] (action, indexPath) in
            self.handleChatAction(indexPath.row)
        }
        chatAction.backgroundColor = Constants.MyNetwork.ChatActionButtonColor
        actions.append(chatAction)
        let removeAction = UITableViewRowAction(style: .Normal, title: "Remove") {
            [unowned self] (action, indexPath) in
            self.handleRemoveAction(indexPath)
        }
        removeAction.backgroundColor = Constants.MyNetwork.RemoveActionButtonColor
        actions.append(removeAction)

        if AppController.shared.currentUserMode.value == .Matchmaker && selectedTab.value.isSingles {
            let matchAction = UITableViewRowAction(style: .Normal, title: "Match") {
                [unowned self] (action, indexPath) in
                self.handleMatchAction(indexPath)
            }
            matchAction.backgroundColor = Constants.MyNetwork.MatchActionButtonColor
            actions.append(matchAction)
        }
        return actions
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    private func handleChatAction(index: Int) {
        self.selectedRow = index
        self.appNavigator?.showAction(identifier: R.segue.myNetworkViewController.toChat.identifier)
    }

    private func handleRemoveAction(indexPath: NSIndexPath) {
        guard let username = contacts[indexPath.row].username else { return }
        myNetworkApi.deleteConnection(username) {
            self.tableView.beginUpdates()
            self.contacts.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
            self.tableView.endUpdates()
        }
    }

    private func handleMatchAction(indexPath: NSIndexPath) {
        switch selectedTab.value.tabKind {
        case .Dates, .Singles:
            self.matchClickedDelegate?.selectSingleForMatching(self.contacts[indexPath.row])
            break
        default:
            self.matchClickedDelegate?.selectMatchmakerForMatching(self.contacts[indexPath.row])
        }
    }

    func handleTabChanged(tab: MyNetworkTab) {
        guard tab != self.selectedTab.value else { return }
        self.selectedTab.next(tab)
    }

    func loadMatchmakers() {
        myNetworkApi.getMatchmakers(0, limit: 1000) { (matchmakers) in
            self.updateTable(matchmakers.map { $0 as UserInfo })
        }
    }

    func loadSingles() {
        myNetworkApi.getSingles(0, limit: 1000) { (singles) in
            self.updateTable(singles.map { $0 as UserInfo })
        }
    }

    func loadDates() {
        myNetworkApi.getDates(0, limit: 1000) {(dates) in
            self.updateTable(dates.map { $0.user as! UserInfo })
        }
    }

    func updateTable(contacts:[UserInfo]) {
        tableView.beginUpdates()
        self.contacts = contacts
        tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Fade)
        tableView.endUpdates()
    }
}

class MyNetworkViewModel: NSObject, ViewModelProtocol {
    var matchClickedDelegate: PersonForMatchingSelected? = nil
    var appNavigator: AppNavigator?
    var myNetworkApi: MyNetworkApiProtocol = MyNetworkApiController()
    var contacts: [UserInfo] = []
    let tableView: UITableView
    var selectedRow: Int = 0
    var selectedTab: Observable<MyNetworkTab> = Observable<MyNetworkTab>(.First)

    var tabsHeader: TabsView

    var tabsViewModel: TabsViewModel {
        let handleTabChangedAction = self.handleTabChanged
        let viewModel = TabsViewModel(tabChangedAction: handleTabChangedAction)
        return viewModel
    }

    lazy var addToNetworkViewModel: AddToNetworkViewModel = {[unowned self] in
        let viewModel = AddToNetworkViewModel(appNavigator: self.appNavigator)
        self.selectedTab.map { $0.tabKind }.bindTo(viewModel.userType)
        return viewModel
    }()

    init(tableView: UITableView, tabsView: TabsView, appNavigator: AppNavigator) {
        self.appNavigator = appNavigator
        self.tableView = tableView
        self.tabsHeader = tabsView
        super.init()
        selectedTab.next(.First)
        selectedTab.observeNew (observeNewTabSelected)
        AppController.shared.currentUserMode.observeNew (self.observeNewMode)
        let handleTabChangedAction = self.handleTabChanged
        let viewModel = TabsViewModel(tabChangedAction: handleTabChangedAction)
        tabsHeader.configure(viewModel)
    }

    func prepareForSegue(segue: UIStoryboardSegue) {
        if segue.identifier == R.segue.myNetworkViewController.toChat.identifier {
            guard let vc = segue.destinationViewController as? ChatViewController else { return }
            vc.interlocutor = contacts[selectedRow]
        }
        if segue.identifier == R.segue.myNetworkViewController.toProfile.identifier {
            guard let vc = segue.destinationViewController as? DateProfileViewController else { return }
            vc.user = contacts[selectedRow]
            vc.selectedTab = selectedTab.value
        }
    }

    func observeNewTabSelected(tab: MyNetworkTab) {
        switch tab.tabKind {
        case .Dates:
            loadDates()
            break
        case .Singles:
            loadSingles()
            break
        case .Matchmakers:
            loadMatchmakers()
            break
        }
    }

    func observeNewMode(mode: Mode) {
        selectedTab.next(.First)
        tabsHeader.configure(tabsViewModel)
        tableView.reloadData()
    }

    func reloadScreenData() {
        observeNewTabSelected(selectedTab.value)
    }
}
