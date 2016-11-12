//
//  ScheduleResultsViewController.swift
//  3Degrees
//
//  Created by Gigster Developer on 9/3/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import SwiftMoment

class ScheduleResultsViewController: UIViewController, ViewProtocol {
    lazy var viewModel: ScheduleResultsViewModel? = {[unowned self] in
        var dates = [Moment]()
        if case .Accept(let proposedDates) = self.mode {
            dates = proposedDates
        }
        guard let user = self.user else { return nil }
        return ScheduleResultsViewModel(appNavigator: self,
                                        mode: self.mode,
                                        dates: dates,
                                        user: user,
                                        tableView: self.selectedDatesTableView)
    }()

    var mode: ScreenMode = .Choose
    var user: UserInfo? = nil

    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var selectedDatesTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if case .Choose = mode {
            title = R.string.localizable.schedulingDateTimesScreenTitle()
        } else {
            title = R.string.localizable.acceptDateTimeScreenTitle()
        }

        applyDefaultStyle()
        configureBindings()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        removeBackButtonsTitle()
        viewModel?.prepareForSegue(segue)
    }

    @IBAction func proceed(sender: AnyObject) {
        viewModel?.proceed()
    }

    @IBAction func unwindToResults(segue: UIStoryboardSegue) {
        viewModel?.handleUwindFromDateTimeSelection(segue)
    }

    func applyDefaultStyle() {
        view.backgroundColor = Constants.ViewOnBackground.Color
        subtitleLabel.applyScheduleDateSubtitleStyles()
    }

    func configureBindings() {
        selectedDatesTableView.delegate = viewModel
        selectedDatesTableView.dataSource = viewModel
        selectedDatesTableView.reloadData()

        switch mode {
        case .Choose:
            titleLabel.text = R.string.localizable.chooseDateTimeTitle()
            subtitleLabel.text = R.string.localizable.chooseDateTimeSubtitle()
            doneButton.setTitle(R.string.localizable.chooseDateTimeDoneButton(),
                                forState: .Normal)
        default:
            titleLabel.text = R.string.localizable.acceptDateTimeTitle()
            subtitleLabel.text = R.string.localizable.acceptDateTimeSubtitle()
            doneButton.setTitle(R.string.localizable.acceptDateTimeDoneButton(),
                                forState: .Normal)
        }

        if case ScreenMode.Choose = mode {
            let tap = UITapGestureRecognizer(
                target: viewModel,
                action: #selector(ScheduleResultsViewModel.showScheduleTimesScreen))
            view.addGestureRecognizer(tap)
        }
    }

    enum ScreenMode {
        case Choose
        case Accept(dates: [Moment])
    }
}
