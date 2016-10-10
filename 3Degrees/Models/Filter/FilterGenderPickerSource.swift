//
//  FilterGenderPickerSource.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/24/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import Bond

class FilterGenderPickerDataSource: NSObject, UIPickerViewDataSource {
    @objc func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    @objc func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return FilterGender.allValues.count
    }
}

class FilterGenderPickerDelegate: NSObject, UIPickerViewDelegate {
    var enumObservableValue: Observable<FilterGender?>

    init(enumObservableValue: Observable<FilterGender?>) {
        self.enumObservableValue = enumObservableValue
    }


    @objc func pickerView(
        pickerView: UIPickerView,
        viewForRow row: Int,
                   forComponent component: Int,
                                reusingView view: UIView?) -> UIView {
        let label = UILabel()
        label.textAlignment = .Center
        let currentValue = FilterGender.allValues[row]
        label.text = currentValue.rawValue
        return label
    }

    @objc func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let selectedRowLabel = pickerView.viewForRow(row, forComponent: component) as? UILabel {
            guard let selectedRowValue = selectedRowLabel.text else {
                return
            }
            enumObservableValue.next(FilterGender(rawValue: selectedRowValue))
        }
    }
}
