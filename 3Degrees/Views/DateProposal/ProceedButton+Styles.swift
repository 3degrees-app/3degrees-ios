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
        let titleAttr = [
            NSForegroundColorAttributeName: Constants.DateProposal.ProceedButtonTextColor,
            NSFontAttributeName: Constants.Fonts.DefaultThin
        ]
        let attributedTitle = NSAttributedString(string: title, attributes: titleAttr)
        setAttributedTitle(attributedTitle, forState: .Normal)
        backgroundColor = Constants.DateProposal.ProceedButtonColor
        setTitleColor(Constants.DateProposal.ProceedButtonTextColor, forState: .Normal)
    }
}
