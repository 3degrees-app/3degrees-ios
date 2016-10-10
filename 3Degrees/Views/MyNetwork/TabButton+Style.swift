//
//  TabButton+Style.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/14/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

extension UIButton {
    func applySelectedTabButtonStyle() {
        self.setTitleColor(UIColor.blackColor(), forState: .Normal)
    }

    func applyNotSelectedTabButtonStyle() {
        self.setTitleColor(Constants.MyNetwork.InfoLabelColor, forState: .Normal)
    }
}
