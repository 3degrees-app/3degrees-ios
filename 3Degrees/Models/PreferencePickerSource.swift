//
//  PreferencePickerSource.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/4/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import Bond

class PreferencePickerDataSource: NSObject, UIPickerViewDataSource {
    @objc func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    @objc func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return UserPreference.allValues.count
    }
}

class PreferencePickerDelegate: NSObject, UIPickerViewDelegate {
    var observableValue: Observable<String?>

    init(observableValue: Observable<String?>) {
        self.observableValue = observableValue
    }


    @objc func pickerView(
        pickerView: UIPickerView,
        viewForRow row: Int,
        forComponent component: Int,
        reusingView view: UIView?) -> UIView {
        let label = UILabel()
        label.textAlignment = .Center
        let currentValue = UserPreference.allValues[row]
        label.text = currentValue.rawValue
        return label
    }

    @objc func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let selectedRowLabel = pickerView.viewForRow(row, forComponent: component) as? UILabel {
            guard let selectedRowValue = selectedRowLabel.text else {
                return
            }
            observableValue.next(selectedRowValue)
        }
    }
}
