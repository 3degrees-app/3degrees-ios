//
//  MessageTableViewCell.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/17/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell, MessageCellProtocol {
    typealias T = MessageCellViewModel
    typealias ContentView = UILabel

    lazy var mainView: ContentView = {
        let label = UILabel()
        label.font = Constants.Fonts.DefaultLight
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .ByWordWrapping
        label.numberOfLines = 100
        return label
    }()
    lazy var datetimeLabel: UILabel = {[unowned self] in
        return self.getDateTimeLabel()
    }()

    private let backView = UIView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        build()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func configure(cellViewModel: T) {
        self.selectionStyle = .None
        contentView.backgroundColor = .clearColor()
        backgroundColor = .clearColor()
        mainView.textColor = Constants.Chat.MessageBodyColor
        if cellViewModel.isMineMessage {
            datetimeLabel.textColor = Constants.Chat.MyMessageDateTimeColor
            backView.backgroundColor = Constants.Chat.MyMessageBackground
        } else {
            datetimeLabel.textColor = Constants.Chat.NotMyMessageDateTimeColor
            backView.backgroundColor = Constants.Chat.NotMyMessageBackground
        }

        mainView.text = cellViewModel.message.message
        datetimeLabel.text = cellViewModel.message.timestamp?.chatFullDate
    }

    func build() {
        backView.translatesAutoresizingMaskIntoConstraints = false
        backView.layer.cornerRadius = 5
        contentView.addSubview(backView)
        contentView.addConstraints(constraintsForBackView())

        buildMainViewAndDatetimeLabel()
        contentView.sendSubviewToBack(backView)
    }

    func constraintsForBackView() -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        let viewsDict = ["view": backView]
        constraints.appendContentsOf(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-8-[view]-8-|",
                options: [],
                metrics: nil,
                views: viewsDict
            )
        )
        constraints.appendContentsOf(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-30-[view]-30-|",
                options: [],
                metrics: nil,
                views: viewsDict
            )
        )
        return constraints
    }

    func constraintsForMainView() -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        let viewsDict = ["view": mainView]
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
                "V:|-32-[view]",
                options: [],
                metrics: nil,
                views: viewsDict
            )
        )
        return constraints
    }

    func constraintsBetweenMainViewAndDateTimeLabel() -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        let viewsDict = ["body": mainView, "datetime": datetimeLabel]
        constraints.appendContentsOf(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[body]-4-[datetime]",
                options: [],
                metrics: nil,
                views: viewsDict
            )
        )
        return constraints
    }
}
