//
//  ActivityTableViewModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/10/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import Router
import Rswift
import ThreeDegreesClient
import SwiftPaginator

extension ActivityTableViewModel: UITableViewDataSource, Routable {
    func tableView(tableView: UITableView,
                   estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityItems.count
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = activityItems[indexPath.row]
        loadNextPageIfNeeded(indexPath.row)
        return getActivityCell(item)
    }

    func getActivityCell(item: Activity) -> UITableViewCell {
        let cellId = R.reuseIdentifier.activityItemTableViewCell.identifier
        guard let typelessCell = tableView.dequeueReusableCellWithIdentifier(cellId)
            else { return UITableViewCell() }
        guard let cell = typelessCell as? ActivityItemTableViewCell else { return typelessCell }
        cell.configure(ActivityItemViewModel(activityItem: item, appNavigator: self.appNavigator))
        return cell
    }
}

extension ActivityTableViewModel: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let username = activityItems[indexPath.row].originUser?.username
            else { return }
        self.routeToProfile(username)
    }

    func tableView(tableView: UITableView,
                   willDisplayCell cell: UITableViewCell,
                   forRowAtIndexPath indexPath: NSIndexPath) {
        let item = activityItems[indexPath.row]
        guard let id = item.id where item.viewedAt == nil else { return }
        api.markAsSeen(Int(id)) {[weak self] in
            guard indexPath.row < self?.activityItems.count else { return }
            self?.activityItems[indexPath.row].viewedAt = NSDate()
        }
    }
}

class ActivityTableViewModel: NSObject, ViewModelProtocol {
    var api: ActivityApiProtocol = ActivityApiController()
    var appNavigator: AppNavigator?
    var activityItems: [Activity] = [Activity]()
    let tableView: UITableView
    var paginator: Paginator<Activity>? = nil
    var refreshCompletedCallback: (() -> ())? = nil
    let router = Router()

    init(tabBarController: UITabBarController, appNavigator: AppNavigator, tableView: UITableView) {
        self.appNavigator = appNavigator
        self.tableView = tableView
        super.init()
        paginator = Paginator(pageSize: 40,
                              fetchHandler: fetchActivityItems,
                              resultsHandler: handleNewPageLoadResults,
                              resetHandler: paginatorResetHandler)
        paginator?.fetchFirstPage()
        AppController.shared.currentUserMode.observeNew(self.handleModeChanged)
        AppController.shared.currentUser.observeNew {[unowned self] (user) in
            self.handleUserChanged()
        }
    }

    func fetchActivityItems(paginator: Paginator<Activity>, page: Int, pageSize: Int) {
        let mode = AppController.shared.currentUserMode.value
        api.getActivities(mode, limit: pageSize, page: page - 1) {(feedItems) in
            if let items = feedItems {
                paginator.receivedResults(items, total: self.activityItems.count + items.count + 1)
                return
            }
            paginator.receivedResults([], total: 0)
        }
    }

    func handleNewPageLoadResults(paginator: Paginator<Activity>, newActivities: [Activity]) {
        tableView.beginUpdates()
        newActivities.forEach {[unowned self] (activity) in
            let indexPath = NSIndexPath(forRow: self.activityItems.count, inSection: 0)
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Bottom)
            self.activityItems.append(activity)
        }
        tableView.endUpdates()
        refreshCompletedCallback?()
    }

    func paginatorResetHandler(paginator: Paginator<Activity>) {
        activityItems = []
        tableView.reloadData()
    }

    func handleUserChanged() {
        reloadData()
    }

    func handleModeChanged(mode: Mode) {
        reloadData()
    }

    func reloadData() {
        paginator?.fetchFirstPage()
    }

    func loadNextPageIfNeeded(lastShowedCellIndex: Int) {
        if lastShowedCellIndex == activityItems.count - 1 {
            paginator?.fetchNextPage()
        }
    }
}
