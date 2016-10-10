//
//  ImageMessageTableViewCell.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/17/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import Kingfisher

class ImageMessageTableViewCell: UITableViewCell, MessageCellProtocol {
    typealias T = MessageCellViewModel
    typealias ContentView = UIImageView

    lazy var datetimeLabel: UILabel = {[unowned self] in
        return self.getDateTimeLabel()
    }()
    lazy var mainView: ContentView = {[unowned self] in
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 320, height: 200))
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

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
        datetimeLabel.textColor = Constants.Chat.ImageDateTimeColor
        imageUrlIf: if let imageUrl = cellViewModel.message.message {
            guard let url = NSURL(string: imageUrl) else { break imageUrlIf}
            mainView.kf_setImageWithURL(url)
        }
        contentView.sendSubviewToBack(mainView)
        datetimeLabel.text = cellViewModel.message.timestamp?.chatFullDate
    }

    func build() {
        buildMainViewAndDatetimeLabel()
        mainView.addConstraint(
            NSLayoutConstraint(
                item: mainView,
                attribute: .Height,
                relatedBy: .Equal,
                toItem: nil,
                attribute: .Height,
                multiplier: 1,
                constant: 200)
        )
    }

    func constraintsForMainView() -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        let viewsDict = ["view": mainView]
        constraints.appendContentsOf(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-0-[view]-0-|",
                options: [],
                metrics: nil,
                views: viewsDict
            )
        )
        constraints.appendContentsOf(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-4-[view]-4-|",
                options: [],
                metrics: nil,
                views: viewsDict
            )
        )
        return constraints
    }

    func constraintsBetweenMainViewAndDateTimeLabel() -> [NSLayoutConstraint] {
        return []
    }
}
