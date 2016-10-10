//
//  AuthButton+Styles.swift
//  3Degrees
//
//  Created by Gigster Developer on 4/27/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

extension UIButton {
    func applyAuthButtonStyles(
        backColor: UIColor = Constants.Auth.ButtonBackgroundColor,
        borderColor: UIColor = Constants.Auth.ButtonBorderColor,
        borderWidth:CGFloat = Constants.Auth.ButtonBorderWidth) {
        self.layer.cornerRadius = self.frame.height / 2
        self.backgroundColor = backColor
        self.setTitleColor(Constants.Auth.ButtonTitleColor, forState: .Normal)
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.CGColor
    }

    func applyFacebookAuthButtonStyles() {
        self.applyAuthButtonStyles(
            Constants.Auth.FacebookButtonBackgroundColor,
            borderColor: Constants.Auth.FacebookButtonBorderColor,
            borderWidth: Constants.Auth.FacebookButtonBorderWidth)
    }
}
