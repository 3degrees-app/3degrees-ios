//
//  UITextField+InputView.swift
//  3Degrees
//
//  Created by Gigster Developer on 4/30/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import Bond

extension UITextField {
    func configureDatePickerInputView(date: NSDate = NSDate()) {
        let birthdayDatePicker = UIDatePicker()
        birthdayDatePicker.datePickerMode = .Date
        birthdayDatePicker.maximumDate = NSDate()
        birthdayDatePicker.backgroundColor = Constants.ViewOnBackground.Color
        self.inputView = birthdayDatePicker
        birthdayDatePicker.bnd_date.next(date)
    }

    func configurePickerView(delegate: UIPickerViewDelegate, dataSource: UIPickerViewDataSource) {
        let picker = UIPickerView()
        picker.dataSource = dataSource
        picker.delegate = delegate
        picker.backgroundColor = Constants.ViewOnBackground.Color
        self.inputView = picker
    }
}
