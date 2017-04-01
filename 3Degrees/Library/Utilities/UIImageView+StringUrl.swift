//
//  UIImageView+StringUrl.swift
//  3Degrees
//
//  Created by Gigster Developer on 7/26/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import Kingfisher
import UIImageView_Letters

extension UIImageView {
    func setAvatarImage(stringUrl: String?, fullName: String, callback: (() -> ())? = nil) {
        let attrs = [
            NSFontAttributeName: fontForFontName(Constants.Fonts.FontNameThin),
            NSForegroundColorAttributeName: UIColor.blackColor()
        ]
        setImageWithString(fullName,
                           color: Constants.Avatar.BackgroundColor,
                           circular: false,
                           textAttributes: attrs)
        guard let imageStringUrl = stringUrl where !imageStringUrl.isEmpty else {
            return
        }
        guard let url = NSURL(string: imageStringUrl) else {
            return
        }
        kf_setImageWithURL(url, placeholderImage: self.image, completionHandler: {(_) in
            callback?()
        })
    }

    private func fontForFontName(fontName: String) -> UIFont {
        let fontSize = self.bounds.width * 0.2
        return UIFont(name:fontName, size:fontSize) ?? UIFont.systemFontOfSize(fontSize)
    }
}
