//
//  AuthTextField+Styles.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/3/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

extension UITextField {
    func applyAuthTextFieldStyles(placeholder: String) {
        let attributes = [NSForegroundColorAttributeName: Constants.Auth.TextFieldPlaceholderColor]
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
        self.tintColor = Constants.Auth.TextFieldPlaceholderColor
        self.textColor = Constants.Auth.TextFieldTextColor
    }
}

extension UIView {
    func applyAuthTextFieldBackgroundStyle() {
        self.backgroundColor = Constants.Auth.TextFieldBackground
        self.layer.cornerRadius = self.frame.height / 2
    }
}
