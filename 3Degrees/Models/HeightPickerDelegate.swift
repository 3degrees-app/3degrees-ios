//
//  HeightPickerSource.swift
//  3Degrees
//
//  Created by Ryan Martin on 11/5/17.
//

import UIKit
import Bond
import ThreeDegreesClient

class HeightPickerDelegate: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {

    static let feetList: [Int] = [4, 5, 6, 7]
    var selectedFeet: String = ""
    var selectedInches: String = ""
    let picker = UIPickerView()
    var textField: UITextField
    
    init(textField: UITextField) {
        self.textField = textField
        super.init()
        picker.dataSource = self
        picker.delegate = self
        picker.backgroundColor = Constants.ViewOnBackground.Color
        self.textField.inputView = picker
        selectedFeet = getFeetString(HeightPickerDelegate.feetList.first!)
        selectedInches = getInchesString(0)
        self.textField.bnd_text.observeNew { (heightOpt) in
            if let height = heightOpt {
                self.preSelect(height)
            }
        }
    }

    @objc func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }

    @objc func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (component == 0) {
            return HeightPickerDelegate.feetList.count
        } else {
            return 12
        }
    }

    func preSelect(heightStr: String) {
        let matches = heightStr.capturedGroups("(\\d+)'\\s+(\\d+)\"")
        if matches.count > 0 {
            if let feet = Int(matches[0]), let feetIndex = HeightPickerDelegate.feetList.indexOf(feet), let inches = Int(matches[1]) {
                picker.selectRow(feetIndex, inComponent: 0, animated: false)
                picker.selectRow(inches, inComponent: 1, animated: false)
                selectedFeet = getFeetString(feet)
                selectedInches = getInchesString(inches)
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
        switch component {
        case 0:
            label.text = getFeetString(HeightPickerDelegate.feetList[row])
        default:
            label.text = getInchesString(row)
        }
        return label
    }
    
    @objc func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let selectedRowLabel = pickerView.viewForRow(row, forComponent: component) as? UILabel {
            guard let selectedRowValue = selectedRowLabel.text else {
                return
            }
            switch (component) {
            case 0:
                selectedFeet = selectedRowValue
            case 1:
                selectedInches = selectedRowValue
            default: break
            }
            textField.bnd_text.next(selectedFeet + " " + selectedInches)
        }
    }

    private func getFeetString(feet: Int)-> String {
        return String(feet) + "'"
    }

    private func getInchesString(inches: Int)-> String {
        return String(inches) + "\""
    }
}

