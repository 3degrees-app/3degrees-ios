//
//  FilterAgeRangePickerSource.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/24/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import Bond

class FilterAgeRangePickerDataSource: NSObject, UIPickerViewDataSource {
    @objc func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }

    @objc func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ?
            FilterAgeRange.allLeftValues.count : FilterAgeRange.allRightValues.count
    }
}

class FilterAgeRangePickerDelegate: NSObject, UIPickerViewDelegate {
    var leftValue: Observable<Int?>
    var rightValue: Observable<Int?>

    init(leftValue: Observable<Int?>,
         rightValue: Observable<Int?>) {
        self.leftValue = leftValue
        self.rightValue = rightValue
    }


    @objc func pickerView(
        pickerView: UIPickerView,
        viewForRow row: Int,
                   forComponent component: Int,
                                reusingView view: UIView?) -> UIView {
        let label = UILabel()
        label.textAlignment = .Center
        let value = component == 0 ?
            FilterAgeRange.allLeftValues[row] : FilterAgeRange.allRightValues[row]
        label.text = FilterAgeRange.getReadableName(value)
        return label
    }

    @objc func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            scrollRightComponentToMinValue(row, pickerView: pickerView)
        } else {
            scrollLeftComponentToMinValue(row, pickerView: pickerView)
        }
        let leftReadableValue = getLeftReadableValue(pickerView)
        let rightReadableValue = getRightReadableValue(pickerView)
        let left = Int(leftReadableValue)
        let right =  Int(rightReadableValue)
        leftValue.next(left)
        rightValue.next(right)
    }

    func scrollLeftComponentToMinValue(selectedRightRow: Int, pickerView: UIPickerView) {
        let selectedLeftRow = pickerView.selectedRowInComponent(0)
        if selectedRightRow < selectedLeftRow - 1 {
            pickerView.selectRow(selectedRightRow + 1, inComponent: 0, animated: true)
        }
    }

    func scrollRightComponentToMinValue(selectedLeftRow: Int, pickerView: UIPickerView) {
        let selectedRightRow = pickerView.selectedRowInComponent(1)
        if selectedLeftRow > selectedRightRow + 1 {
            pickerView.selectRow(selectedLeftRow - 1, inComponent: 1, animated: true)
        }
    }

    func getLeftReadableValue(pickerView: UIPickerView) -> String {
        return getReadableValue(pickerView, row: pickerView.selectedRowInComponent(0), component: 0)
    }

    func getRightReadableValue(pickerView: UIPickerView) -> String {
        return getReadableValue(pickerView, row: pickerView.selectedRowInComponent(1), component: 1)
    }

    func getReadableValue(pickerView: UIPickerView, row: Int, component: Int) -> String {
        if let selectedRowLabel = pickerView.viewForRow(row, forComponent: component) as? UILabel {
            guard let selectedRowValue = selectedRowLabel.text else {
                return ""
            }
            return selectedRowValue
        }
        return ""
    }
}
