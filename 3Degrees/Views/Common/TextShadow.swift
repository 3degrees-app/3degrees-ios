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
        self.layer.shadowOffset = CGSize()
        self.layer.shadowRadius = Constants.Profile.TextShadowRadius
        self.layer.shadowOpacity = 1
    }
}

extension UILabel {
    func dropShadow(radius: CGFloat = Constants.Profile.TextShadowRadius) {
        self.shadowColor = Constants.Profile.TextShadowColor
        self.shadowOffset = CGSize()
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = CGSize()
    }
}

extension UITextField {
    func dropShadow() {
        let shadow = NSShadow()
        shadow.shadowColor = Constants.Profile.TextShadowColor
        shadow.shadowOffset = CGSize()
        shadow.shadowBlurRadius = Constants.Profile.TextShadowRadius
        self.defaultTextAttributes[NSShadowAttributeName] = shadow
    }
}
