//
//  AvatarImageView+Styles.swift
//  3Degrees
//
//  Created by Gigster Developer on 4/28/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

extension UIImageView {
    func applyLeftMenuAvatarStyles() {
        applyDefaultAvatarStyle()
        self.layer.borderWidth = 7
        self.layer.borderColor = Constants.LeftMenu.AvatarBorderColor.CGColor
    }

    func applyDefaultAvatarStyle() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
        self.contentMode = UIViewContentMode.ScaleAspectFill
    }
}
