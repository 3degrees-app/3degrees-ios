//
//  MessageCellProtocol.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/17/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

protocol MessageCellProtocol: TableCellProtocol {
    associatedtype ContentView: UIView

    var datetimeLabel: UILabel { get }
    var mainView: ContentView { get }

    func build()
    func buildMainViewAndDatetimeLabel()
    func constraintsForDateTimeLabel() -> [NSLayoutConstraint]
    func constraintsForMainView() -> [NSLayoutConstraint]
    func constraintsBetweenMainViewAndDateTimeLabel() -> [NSLayoutConstraint]
}

extension MessageCellProtocol where Self: UITableViewCell {

    func buildMainViewAndDatetimeLabel() {
        contentView.addSubview(datetimeLabel)
        contentView.addConstraints(constraintsForDateTimeLabel())
        contentView.addSubview(mainView)
        contentView.addConstraints(constraintsForMainView())
        contentView.addConstraints(constraintsBetweenMainViewAndDateTimeLabel())
        contentView.bringSubviewToFront(datetimeLabel)
    }

    func constraintsForDateTimeLabel() -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        let viewsDict = ["view": datetimeLabel]
        constraints.appendContentsOf(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-58-[view]-58-|",
                options: [],
                metrics: nil,
                views: viewsDict
            )
        )
        constraints.appendContentsOf(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[view]-32-|",
                options: [],
                metrics: nil,
                views: viewsDict
            )
        )
        return constraints
    }

    func getDateTimeLabel() -> UILabel {
        let label = UILabel()
        var font = UIFont.systemFontOfSize(10, weight: UIFontWeightLight)
        if let f = UIFont(name: "HelveticaNeue-Light", size: 10) {
            font = f
        }
        label.font = font
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .ByWordWrapping
        label.numberOfLines = 1
        label.setContentHuggingPriority(252, forAxis: UILayoutConstraintAxis.Vertical)
        return label
    }
}
