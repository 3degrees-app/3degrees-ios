//
//  AuthenticationViewController.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/2/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

extension UIViewController {
    func applyAuthBackgroundImage() {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        let backgroundImageView = UIImageView(image: UIImage(named: "authBackground"))
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        let overlayView = UIView()
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.backgroundColor = Constants.Auth.BackgroundOverlayColor

        view.addSubview(backgroundImageView)
        view.addSubview(overlayView)
        view.sendSubviewToBack(overlayView)
        view.sendSubviewToBack(backgroundImageView)

        var allConstraints = [NSLayoutConstraint]()
        let verticalFormat   = "V:|-0-[view]-0-|"
        let horizontalFormat = "H:|-0-[view]-0-|"

        allConstraints.appendContentsOf(
            getAttachedToSuperviewConstraints(backgroundImageView, format: verticalFormat)
        )

        allConstraints.appendContentsOf(
            getAttachedToSuperviewConstraints(backgroundImageView, format: horizontalFormat)
        )

        allConstraints.appendContentsOf(
            getAttachedToSuperviewConstraints(overlayView, format: horizontalFormat)
        )

        allConstraints.appendContentsOf(
            getAttachedToSuperviewConstraints(overlayView, format: verticalFormat)
        )
        view.addConstraints(allConstraints)

        tableViewSetUp: if self.view is UITableView {
            view.frame = self.view.bounds
            view.translatesAutoresizingMaskIntoConstraints = true
            guard let tableView = self.view as? UITableView else { break tableViewSetUp }
            tableView.backgroundView = view
        } else {
            self.view.addSubview(view)
            self.view.sendSubviewToBack(view)
            self.view.addConstraints(getAttachedToSuperviewConstraints(view, format: horizontalFormat))
            self.view.addConstraints(getAttachedToSuperviewConstraints(view, format: verticalFormat))
        }
    }

    private func getAttachedToSuperviewConstraints(view: UIView, format: String) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraintsWithVisualFormat(
            format,
            options: [],
            metrics: nil,
            views: ["view": view]
        )
    }
}
