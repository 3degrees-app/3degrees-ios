//
//  ProceedButton+Styles.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/10/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

extension UIButton {
    func configureProceedButton(title: String) {
        var font = UIFont.systemFontOfSize(18, weight: UIFontWeightThin)
        if let f = UIFont(name: "HelveticaNeue-Thin", size: 18) {
            font = f
        }
        let titleAttr = [
            NSForegroundColorAttributeName: Constants.DateProposal.ProceedButtonTextColor,
            NSFontAttributeName: font
        ]
        let attributedTitle = NSAttributedString(string: title, attributes: titleAttr)
        setAttributedTitle(attributedTitle, forState: .Normal)
        backgroundColor = Constants.DateProposal.ProceedButtonColor
        setTitleColor(Constants.DateProposal.ProceedButtonTextColor, forState: .Normal)
    }
}
