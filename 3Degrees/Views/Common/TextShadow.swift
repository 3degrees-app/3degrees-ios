//
//  TextShadow.swift
//  3Degrees
//
//  Created by Gigster Developer on 10/6/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

extension UIButton {
    func dropShadow() {
        self.layer.shadowColor = Constants.Profile.TextShadowColor.CGColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = Constants.Profile.TextShadowRadius
        self.layer.shadowOffset = CGSize()
        self.layer.backgroundColor = UIColor.clearColor().CGColor
    }
}

extension UILabel {
    func dropShadow(radius: CGFloat = Constants.Profile.TextShadowRadius) {
        self.layer.shadowColor = Constants.Profile.TextShadowColor.CGColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = Constants.Profile.TextShadowRadius
        self.layer.shadowOffset = CGSize()
        self.layer.backgroundColor = UIColor.clearColor().CGColor
    }
}

extension UITextField {
    func dropShadow() {
        self.layer.shadowColor = Constants.Profile.TextShadowColor.CGColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = Constants.Profile.TextShadowRadius
        self.layer.shadowOffset = CGSize()
        self.layer.backgroundColor = UIColor.clearColor().CGColor
    }
}
