//
//  UITextView+EditProfileStyle.swift
//  3Degrees
//
//  Created by Gigster Developer on 4/29/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

extension UITextView {
    func applyOneLineWithoutPaddingsRules() {
        self.textContainer.maximumNumberOfLines = 1
        self.textContainer.lineBreakMode = .ByTruncatingTail
        removePadding()
    }

    func removePadding() {
        self.textContainerInset = UIEdgeInsetsZero
        self.textContainer.lineFragmentPadding = 0
    }
}
