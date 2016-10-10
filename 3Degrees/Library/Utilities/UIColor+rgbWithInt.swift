//
//  UIColorExtension.swift
//  3Degrees
//
//  Created by Gigster Developer on 4/26/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r: Int, g: Int, b: Int) {
        self.init(r: r, g: g, b: b, a: 1.0)
    }

    convenience init(r: Int, g: Int, b: Int, a: CGFloat) {
        let red = CGFloat(r)/255
        let green = CGFloat(g)/255
        let blue = CGFloat(b)/255
        self.init(red: red, green: green, blue: blue, alpha: a)
    }
}
