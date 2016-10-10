//
//  ScheduleResultsViewModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 9/4/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation
import Bond
import SwiftMoment

class ScheduleResultsViewModel: NSObject, ViewModelProtocol {
    var api: DateProposalApiProtocol = DateProposalApiController()
    var router: RoutingProtocol?
    var user: UserInfo
    var selectedDateTimes: Observable<[Moment]>
    var mode: ScheduleResultsViewController.ScreenMode
    var tableView: UITableView

    init(router: RoutingProtocol,
         mode: ScheduleResultsViewController.ScreenMode,
         dates: [Moment] = [],
         user: UserInfo,
         tableView: UITableView) {
        self.router = router
        self.mode = mode
        self.selectedDateTimes = Observable(dates)
        self.user = user
        self.tableView = tableView
        super.init()
        self.selectedDateTimes.observe {[weak self] (datess) in
            self?.tableView.reloadData()
        }
        loadAlreadyProposedDateTimes()
    }

    func proceed() {
        switch mode {
        case .Choose:
            guard let username = user.username else { return }
            api.suggestDates(username,
                             dates: selectedDateTimes.value.map { $0.date }) {[weak self] in
                self?.router?.popAction()
            }
        default:
            router?.showAction(identifier: R.segue.scheduleResultsViewController
                                                  .fromScheduleToChat.identifier)
        }
    }

    func prepareForSegue(segue: UIStoryboardSegue) {
        if let viewController = segue.destinationViewController as? ChatViewController {
            viewController.interlocutor = user
        } else if let viewController = segue.destinationViewController as? ScheduleDateTimeViewController {
            viewController.dates = selectedDateTimes.value
        }
    }

    func handleUwindFromDateTimeSelection(segue: UIStoryboardSegue) {
        guard let viewController = segue.sourceViewController
            as? ScheduleDateTimeViewController
            else { return }
        selectedDateTimes.next(viewController.viewModel.selectedDateTimes)
    }

    func loadAlreadyProposedDateTimes() {
        guard let username = user.username else { return }
        api.getSuggestedTimes(username) {[weak self] (dates) in
            self?.selectedDateTimes.next(dates.map { moment($0) })
        }
    }
}

extension ScheduleResultsViewModel: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return selectedDateTimes.value.count + 1
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        guard indexPath.row < selectedDateTimes.value.count else {
            return UITableViewAutomaticDimension
        }
        return 38
    }

    func tableView(tableView: UITableView,
                   estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 38
    }

    func tableView(tableView: UITableView,
                   cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard indexPath.row < selectedDateTimes.value.count else {
            let cellId = R.reuseIdentifier.descriptionCell.identifier
            guard let cell = tableView.dequeueReusableCellWithIdentifier(
                    cellId
                ) as? ProposedDatesDescriptionTableViewCell else { return UITableViewCell() }
            cell.configure(ProposedDatesDescriptionCellViewModel(mode: mode))
            return cell
        }
        let cellId: String
        switch mode {
        case .Choose:
            cellId = R.reuseIdentifier.selectedDateCell.identifier
        default:
            cellId = R.reuseIdentifier.acceptSelectedDateCell.identifier
        }
        guard let cell = tableView.dequeueReusableCellWithIdentifier(
            cellId
            ) as? SelectedDateTimeTableViewCell else { return UITableViewCell() }
        let viewModel = SelectedDateTimeCellViewModel(
            value: selectedDateTimes.value[indexPath.row],
            router: router,
            user: user,
            mode: mode)
        cell.configure(viewModel)
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }

    func showScheduleTimesScreen() {
        router?.showAction(identifier: R.segue.scheduleResultsViewController.scheduleDateTime.identifier)
    }
}
