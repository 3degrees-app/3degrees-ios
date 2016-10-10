//
//  ViewProtocol.swift
//  3Degrees
//
//  Created by Gigster Developer on 4/27/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

protocol ViewProtocol {
    func applyDefaultStyle()
    func configureBindings()
}

extension ViewProtocol where Self: UIViewController {
    func removeBackButtonsTitle() {
        let titlelessBackBarButton = UIBarButtonItem()
        titlelessBackBarButton.title = "  "
        navigationItem.backBarButtonItem = titlelessBackBarButton
    }
}
