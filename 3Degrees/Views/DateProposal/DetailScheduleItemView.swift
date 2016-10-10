//
//  DetailScheduleItemView.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/10/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import Bond
import PureLayout

class DetailScheduleItemView: UILabel {

    func configure(value: String, selected: Bool, disabled: Bool) {
        text = value
        applyDefaultStyle()
        if selected {
            applySelectedStyle()
        }
        if disabled {
            applyDisabledStyle()
        }
    }

    func applyDefaultStyle() {
        self.layer.borderWidth = 1
        self.layer.borderColor = Constants.DateProposal.DetailItemBorderColor.CGColor
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.height / 2
        self.backgroundColor = Constants.DateProposal.DetailItemColor
        self.textColor = Constants.DateProposal.DetailItemTextColor
        self.textAlignment = NSTextAlignment.Center
        guard let font = UIFont(name: "HelveticaNeue-Light", size: 12) else {
            return
        }
        self.font = font
    }

    func applySelectedStyle() {
        self.layer.borderWidth = 1
        self.layer.borderColor = Constants.DateProposal.DetailItemSelecteBorderColor.CGColor
        self.backgroundColor = Constants.DateProposal.DetailItemSelectedColor
        self.textColor = Constants.DateProposal.DetailItemSelectedTextColor
        guard let font = UIFont(name: "HelveticaNeue-Light", size: 12) else {
            return
        }
        self.font = font
    }

    func applyDisabledStyle() {
        self.userInteractionEnabled = false
        self.textColor = UIColor.lightGrayColor()
    }

    func applyFixedStyle() {
        self.userInteractionEnabled = false
        self.layer.borderWidth = 1
        self.layer.borderColor = Constants.DateProposal.DetailItemFixedColor.CGColor
        self.backgroundColor = Constants.DateProposal.DetailItemFixedColor
        self.textColor = UIColor.blackColor()
        guard let font = UIFont(name: "HelveticaNeue-Light", size: 12) else {
            return
        }
        self.font = font
    }
}
