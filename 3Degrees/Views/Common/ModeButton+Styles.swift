//
//  ModeButton+Styles.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/5/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

extension UIButton {
    func applyModeButtonStyles() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.borderColor = Constants.Mode.ButtonBorderColor.CGColor
        self.layer.borderWidth = Constants.Mode.ButtonBorderWidth

        self.adjustsImageWhenHighlighted = false
        self.clipsToBounds = true

        self.setBackougound(Constants.Mode.ButtonSelectedBackColor, forState: .Highlighted)
        self.setBackougound(Constants.Mode.ButtonSelectedBackColor, forState:  .Selected)
        self.setBackougound(Constants.Mode.ButtonBackColor, forState: .Normal)
        self.setTitleColor(Constants.Mode.ButtonTextColor, forState: .Normal)
        self.setTitleColor(Constants.Mode.ButtonSelectedTextColor, forState: .Highlighted)
    }

    private func setBackougound(color: UIColor, forState state: UIControlState) {
        self.setBackgroundImage(imageWithColor(color), forState: state)
    }

    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContextRef = UIGraphicsGetCurrentContext()!

        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)

        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return image
    }
}
