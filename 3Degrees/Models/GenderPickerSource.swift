//
//  GenderPickerSource.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/4/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import Bond
import ThreeDegreesClient

class GenderPickerDataSource: NSObject, UIPickerViewDataSource {
    @objc func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    @objc func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
}

class GenderPickerDelegate: NSObject, UIPickerViewDelegate {

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
        label.text = row == 0 ?
            PrivateUser.Gender.Male.rawValue.capitalizedString :
            PrivateUser.Gender.Female.rawValue.capitalizedString
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
