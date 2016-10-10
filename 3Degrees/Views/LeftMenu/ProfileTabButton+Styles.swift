//
//  ProfileTabButton+Styles.swift
//  3Degrees
//
//  Created by Gigster Developer on 4/28/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

extension UIButton {
    func applyLeftMenuTabButtonStyles() {
        self.backgroundColor = UIColor.clearColor()
        self.setTitleColor(Constants.Profile.InfoLabelColor, forState: .Normal)
        self.dropShadow()
    }

    func applySelectedStyles() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor(white: 1, alpha: 1).CGColor
        self.backgroundColor = UIColor.clearColor()
    }

    func deselect() {
        self.layer.cornerRadius = 0
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.clearColor().CGColor
    }
}
