//
//  ModeInfoLabel+Styles.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/5/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

extension UILabel {
    func applyModeInfoLabelStyles() {
        self.textColor = Constants.Mode.LabelInfoColor
    }

    func applyModeLogoLabelStyles() {
        self.textColor = Constants.Mode.LabelLogoColor
    }
}
