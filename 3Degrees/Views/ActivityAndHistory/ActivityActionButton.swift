//
//  ActivityActionButton.swift
//  3Degrees
//
//  Created by Gigster Developer on 8/16/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

protocol ActivityActionButton {
    func configureAcceptButton(title: String)
    func configureDeclineButton(title: String)
    func configureViewButton(title: String)
    func configureTextButton(title: String)
    func configureActivityActionButton(title: String, textColor: UIColor, background: UIColor)
}

extension UIButton: ActivityActionButton {

    private var defaultActionWidth: CGFloat {
        return 85
    }

    func configureAcceptButton(title: String) {
        configureActivityActionButton(title,
                                      textColor: Constants.ActivityAndHistory.AcceptButtonTextColor,
                                      background: Constants.ActivityAndHistory.AcceptButtonColor)
        addWidthConstraint(defaultActionWidth)
    }

    func configureDeclineButton(title: String) {
        configureActivityActionButton(title,
                                      textColor: Constants.ActivityAndHistory.DeclineButtonTextColor,
                                      background: Constants.ActivityAndHistory.DeclineButtonColor)
        addWidthConstraint(defaultActionWidth)
    }

    func configureViewButton(title: String) {
        configureActivityActionButton(title.capitalizedString,
                                      textColor: .blackColor(),
                                      background: .clearColor())
    }

    func configureTextButton(title: String) {
        configureActivityActionButton(title, textColor: .blackColor(), background: .clearColor())
        userInteractionEnabled = false
    }

    func addWidthConstraint(width: CGFloat) {
        let widthConstraint = NSLayoutConstraint(item: self,
                                                 attribute: .Width,
                                                 relatedBy: .Equal,
                                                 toItem: nil,
                                                 attribute: .Width,
                                                 multiplier: 1.0,
                                                 constant: width)
        addConstraint(widthConstraint)
    }

    func configureActivityActionButton(title: String, textColor: UIColor, background: UIColor) {
        translatesAutoresizingMaskIntoConstraints = false
        hidden = false
        var font = UIFont.systemFontOfSize(18)
        if let f = UIFont(name: "HelveticaNeue", size: 15) {
            font = f
        }
        let attrs = [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: textColor,
        ]
        setAttributedTitle(NSAttributedString(string: title, attributes: attrs),
                           forState: .Normal)
        backgroundColor = background
        layer.cornerRadius = 5
        userInteractionEnabled = true
    }
}
