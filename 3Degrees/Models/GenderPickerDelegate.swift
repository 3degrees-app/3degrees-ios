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

class GenderPickerDelegate: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    static let genders = [PrivateUser.Gender.Male, PrivateUser.Gender.Female]
    let picker = UIPickerView()
    var textField: UITextField

    @objc func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    @objc func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }

    init(textField: UITextField) {
        self.textField = textField
        super.init()
        picker.dataSource = self
        picker.delegate = self
        picker.backgroundColor = Constants.ViewOnBackground.Color
        self.textField.inputView = picker
        self.textField.bnd_text.observeNew { (genderOpt) in
            if let gender = genderOpt {
                self.preSelect(gender)
            }
        }
    }

    func preSelect(genderStr: String) {
        if let gender = PrivateUser.Gender.init(rawValue: genderStr.lowercaseString) {
            if let index = GenderPickerDelegate.genders.indexOf(gender) {
                picker.selectRow(index, inComponent: 0, animated: false)
            }
        }
    }

    @objc func pickerView(
        pickerView: UIPickerView,
        viewForRow row: Int,
        forComponent component: Int,
        reusingView view: UIView?) -> UIView {
        let label = UILabel()
        label.textAlignment = .Center
        label.text = GenderPickerDelegate.genders[row].rawValue.capitalizedString
        return label
    }

    @objc func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let selectedRowLabel = pickerView.viewForRow(row, forComponent: component) as? UILabel {
            guard let selectedRowValue = selectedRowLabel.text else {
                return
            }
            textField.bnd_text.next(selectedRowValue)
        }
    }
}
