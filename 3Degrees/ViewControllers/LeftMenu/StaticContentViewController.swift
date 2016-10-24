//
//  StaticContentViewController.swift
//  3Degrees
//
//  Created by Gigster Developer on 6/1/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import FLTextView
import TSMarkdownParser

class StaticContentViewController: UIViewController, ViewProtocol {
    private lazy var viewModel: StaticContentViewModel = {[unowned self] in
        let viewModel = StaticContentViewModel(router: self, contentType: self.actionType)
        viewModel.loadContent()
        return viewModel
    }()

    @IBOutlet weak var textView: FLTextView!

    var actionType: AccountAction!

    override func viewDidLoad() {
        applyDefaultStyle()
        configureBindings()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    func applyDefaultStyle() {
        title = actionType.rawValue
    }

    func configureBindings() {
        viewModel.content.observeNew { (content) in
            self.textView.attributedText =
                TSMarkdownParser.standardParser().attributedStringFromMarkdown(content)
        }
    }
}
