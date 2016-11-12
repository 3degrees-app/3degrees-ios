//
//  ScheduleDateTimeViewModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 9/3/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import JTAppleCalendar
import SwiftMoment
import Bond

class ScheduleDateTimeViewModel: NSObject, ViewModelProtocol {
    var dates: [Moment] = []
    var appNavigator: AppNavigator? = nil

    var currentDate: Moment
    var selectedDateTimes: [Moment]
    var possibleTimes: [Duration]

    var timesCollectionView: UICollectionView
    var calendarView: JTAppleCalendarView
    var selectedDatesCount: Observable<Int>
    var currentMonthName: Observable<String>

    convenience init(dates: [NSDate],
                     appNavigator: AppNavigator?,
                     timesCollection: UICollectionView,
                     calendarView: JTAppleCalendarView,
                     selectedDatesCount: Observable<Int>) {
        self.init(dates: dates.map { moment($0) },
                  appNavigator: appNavigator,
                  timesCollection: timesCollection,
                  calendarView: calendarView,
                  selectedDatesCount: selectedDatesCount)
    }

    init(dates: [Moment],
         appNavigator: AppNavigator?,
         timesCollection: UICollectionView,
         calendarView: JTAppleCalendarView,
         selectedDatesCount: Observable<Int>) {
        self.dates = dates
        self.currentDate = dates.first ?? moment()
        self.selectedDateTimes = dates
        self.appNavigator = appNavigator
        let baseDuration = 43200 // 12 PM in seconds
        self.timesCollectionView = timesCollection
        self.calendarView = calendarView
        self.calendarView.scrollEnabled = false
        self.selectedDatesCount = selectedDatesCount
        self.currentMonthName = Observable<String>("")
        self.possibleTimes = (0...21).map { Duration(value: baseDuration + 30 * 60 * $0) }
    }

    func done() {
        appNavigator?.showAction(identifier: R.segue.scheduleDateTimeViewController
                                              .doneSelectingDates.identifier)
    }

    func prevMonth() {
        calendarView.scrollToPreviousSegment(true)
    }

    func nextMonth() {
        calendarView.scrollToNextSegment(true)
    }
}

extension ScheduleDateTimeViewModel:UICollectionViewDelegate,
                                     UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return possibleTimes.count
    }

    func collectionView(collectionView: UICollectionView,
                        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellId = R.reuseIdentifier.timeCell.identifier
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            cellId,
            forIndexPath: indexPath) as? ProposedTimeCollectionViewCell
            else { return UICollectionViewCell() }
        let duration = possibleTimes[indexPath.item]
        let dateTime = currentDate.dateWithoutTime + duration
        let disabled = dateTime < moment()
        let selected = selectedDateTimes.contains { dateTime == $0 }
        let viewModel = ProposedTimeCellViewModel(value: dateTime.format("hh:mm a"),
                                                  selected: selected,
                                                  disabled: disabled && !selected)
        cell.configure(viewModel)
        return cell
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let duration = possibleTimes[indexPath.item]
        let dateTime = currentDate.dateWithoutTime + duration
        if dateTime < moment() {
            collectionView.deselectItemAtIndexPath(indexPath, animated: true)
            return
        }
        let i = selectedDateTimes.indexOf { $0 == dateTime }
        if let indexOf = i {
            selectedDateTimes.removeAtIndex(indexOf)
        } else {
            guard selectedDateTimes.count < 5 else { return }
            selectedDateTimes.append(dateTime)
        }
        selectedDatesCount.next(selectedDateTimes.count)
        collectionView.reloadItemsAtIndexPaths([indexPath])
    }
}

extension ScheduleDateTimeViewModel: JTAppleCalendarViewDelegate,
                                     JTAppleCalendarViewDataSource {
    func configureCalendar(calendar: JTAppleCalendarView) ->
        (startDate: NSDate, endDate: NSDate, numberOfRows: Int, calendar: NSCalendar) {
        let startDate = moment()
        currentMonthName.next(startDate.format("MMMM, yyyy"))
        return (startDate.date, moment().add(6, .Months).date, 5, NSCalendar.currentCalendar())
    }

    func calendar(calendar: JTAppleCalendarView,
                  isAboutToDisplayCell cell: JTAppleDayCellView,
                                       date: NSDate,
                                       cellState: CellState) {
        guard let cell = cell as? DayView else { return }
        let date = moment(date)
        let isSelected = selectedDateTimes.contains {
            $0.isSameDate(date)
        } || date.isSameDate(currentDate)
        cell.configureBeforeDisplay(cellState, date: moment(date), isSelected: isSelected)
    }

    func calendar(calendar: JTAppleCalendarView,
                  didDeselectDate date: NSDate,
                                  cell: JTAppleDayCellView?,
                                  cellState: CellState) {
        calendar.reloadDates([date])
    }

    func calendar(calendar: JTAppleCalendarView,
                  didSelectDate date: NSDate,
                                cell: JTAppleDayCellView?,
                                cellState: CellState) {
        let prevDate = currentDate
        let date = moment(date)
        currentDate = date
        calendar.reloadDates([date.date, prevDate.date])
        timesCollectionView.reloadData()
    }

    func calendar(calendar: JTAppleCalendarView,
                  didScrollToDateSegmentStartingWithdate startDate: NSDate,
                                          endingWithDate endDate: NSDate) {
        currentMonthName.next(moment(startDate).format("MMMM, yyyy"))
    }
}
