//
//  AccountViewController.swift
//  3Degrees
//
//  Created by Gigster Developer on 4/28/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import DynamicBlurView

class AccountViewController: UIViewController, ViewProtocol {
    private lazy var viewModel: AccountViewModel = {[unowned self] () in
        return AccountViewModel(actionTableView: self.actionTableView, router: self)
    }()

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var avatarBackgroundImageView: UIImageView!
    @IBOutlet weak var bluredView: DynamicBlurView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userInfoLabel: UILabel!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var generalButton: UIButton!
    @IBOutlet weak var supportButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var actionTableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()
        applyDefaultStyle()
        configureBindings()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        actionTableView.reloadData()
        AppController.shared.registerForRemoteNotifications()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.viewModel.prepareForSegue(segue)
    }

    func applyDefaultStyle() {
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.view.backgroundColor = Constants.ViewOnBackground.Color
        self.generalButton.applyAccountTabButtonStyles()
        self.generalButton.applySelectedStyles()
        self.supportButton.applyAccountTabButtonStyles()
        self.aboutButton.applyAccountTabButtonStyles()
        self.userInfoLabel.applyAccountInfoLabelStyles()
        self.nameLabel.applyAccountInfoLabelStyles()

        self.actionTableView.separatorColor = Constants.Account.ActionTableSeparatorColor
        self.actionTableView.tableFooterView = UIView()
        self.actionTableView.tableHeaderView = UIView()

        self.bluredView.backgroundColor = UIColor(r: 255, g: 255, b: 255, a: 0.3)

        self.bluredView.blurRadius = 10
        self.bluredView.blurRatio = 10

        self.avatarImageView.applyAccountAvatarStyles()

        self.view.sendSubviewToBack(self.bluredView)
        self.view.sendSubviewToBack(self.avatarBackgroundImageView)
    }

    func configureBindings() {
        self.generalButton.bnd_tap.observe {[unowned self] () in
            self.handleTabChanged(.General)
        }

        self.aboutButton.bnd_tap.observe {[unowned self] () in
            self.handleTabChanged(.About)
        }

        self.supportButton.bnd_tap.observe {[unowned self] () in
            self.handleTabChanged(.Support)
        }

        self.returnButton.bnd_tap.observe { () in
            self.viewModel.returnBack()
        }

        viewModel.observableName.bindTo(nameLabel.bnd_text)
        viewModel.observableUserInfo.bindTo(userInfoLabel.bnd_text)
        viewModel.observableAvatarImage.observe {[unowned self] in
            let fullName = self.viewModel.observableName.value ?? ""
            self.avatarImageView.setAvatarImage($0, fullName: fullName) {
                self.bluredView.refresh()
            }
            self.avatarBackgroundImageView.setAvatarImage($0, fullName: fullName) {
                self.bluredView.refresh()
            }
            self.bluredView.refresh()
        }

        actionTableView.dataSource = viewModel
        actionTableView.delegate = viewModel
    }

    private func deselectTabButton() {
        switch viewModel.menuMode {
        case .About:
            self.aboutButton.deselect()
            break
        case .General:
            self.generalButton.deselect()
            break
        case .Support:
            self.supportButton.deselect()
            break
        }
    }

    private func selectTabButton() {
        switch viewModel.menuMode {
        case .About:
            self.aboutButton.applySelectedStyles()
            break
        case .General:
            self.generalButton.applySelectedStyles()
            break
        case .Support:
            self.supportButton.applySelectedStyles()
            break
        }
    }

    private func handleTabChanged(mode: AccountMode) {
        deselectTabButton()
        viewModel.menuMode = mode
        selectTabButton()
    }
}
