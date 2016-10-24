//
//  ProfileInfoLabel+Styles.swift
//  3Degrees
//
//  Created by Gigster Developer on 4/28/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import QuartzCore

extension UILabel {
    func applyAccountInfoLabelStyles() {
        self.textColor = Constants.Profile.InfoLabelColor
        self.shadowOffset = CGSize()
        self.layer.shadowOpacity = 1
        self.shadowColor = Constants.Profile.TextShadowColor
        self.layer.shadowRadius = Constants.Profile.TextShadowRadius
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize()
    }
}
