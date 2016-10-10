//
//  ScheduleDateTimeViewController.swift
//  3Degrees
//
//  Created by Gigster Developer on 9/3/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import JTAppleCalendar
import SwiftMoment
import Bond

class ScheduleDateTimeViewController: UIViewController, ViewProtocol {
    lazy var viewModel: ScheduleDateTimeViewModel = {[unowned self] in
        return ScheduleDateTimeViewModel(dates: self.dates,
                                         router: self,
                                         timesCollection: self.timesCollectionView,
                                         calendarView: self.calendarView,
                                         selectedDatesCount: self.selectedDatesCount)
    }()

    var dates: [Moment] = []
    var selectedDatesCount: Observable<Int> = Observable(0)

    @IBOutlet weak var monthName: UILabel!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var timesCollectionView: UICollectionView!
    @IBOutlet weak var countOfSelectedDatesLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var prevMonthButton: UIButton!
    @IBOutlet weak var nextMonthButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.chooseDateTimesScreenTitle()
        applyDefaultStyle()
        configureBindings()
    }

    func applyDefaultStyle() {
        self.view.backgroundColor = Constants.ViewOnBackground.Color
        self.calendarView.cellInset = CGPoint()
    }

    func configureBindings() {
        selectedDatesCount.next(dates.count)
        selectedDatesCount.map { count in
            String(count) + R.string.localizable.numberOfSelectedDates()
            }.observe {[weak self] s in
                self?.countOfSelectedDatesLabel.bnd_text.next(s)
        }
        doneButton.bnd_tap.observe {[weak self] in self?.viewModel.done() }
        self.calendarView.delegate = viewModel
        self.calendarView.dataSource = viewModel
        self.calendarView.registerCellViewXib(fileName: "DayView")
        self.calendarView.scrollEnabled = false
        self.calendarView.cellInset = CGPoint()
        self.timesCollectionView.delegate = viewModel
        self.timesCollectionView.dataSource = viewModel
        viewModel.currentMonthName.bindTo(monthName.bnd_text)
        prevMonthButton.bnd_tap.observe {[weak self] in
            self?.viewModel.prevMonth()
        }
        nextMonthButton.bnd_tap.observe {[weak self] in
            self?.viewModel.nextMonth()
        }
    }
}
