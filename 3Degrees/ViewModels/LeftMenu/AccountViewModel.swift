//
//  AccountViewModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 4/28/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation
import UIKit
import Bond
import FBSDKLoginKit
import MessageUI
import Router
import ThreeDegreesClient

extension AccountViewModel: UITableViewDelegate, Routable {
    func tableView(tableView: UITableView,
                   heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch menuMode {
        case .General:
            handleGeneralAction(indexPath.row, actions: AccountAction.generalActions)
            break
        case .About:
            handleStaticContentAction(AccountAction.aboutActions[indexPath.row])
            break
        case .Support:
            handleStaticContentAction(AccountAction.supportActions[indexPath.row])
            break
        }
    }

    func handleGeneralAction(index: Int, actions: [AccountAction]) {
        let currentAction = actions[index]
        switch currentAction {
        case .EditProfile:
            let segueId = R.segue.accountViewController.toEdit.identifier
            appNavigator?.showAction(identifier: segueId)
            break
        case .LogOut:
            logout()
            break
        case .InviteMatchMaker:
            handleInviteUser(StaticContentType.InviteMessageMM)
            break
        case .InviteSingle:
            handleInviteUser(StaticContentType.InviteMessageSingle)
            break
        case .SwitchMode:
            let currentMode = AppController.shared.currentUserMode.value
            AppController.shared.currentUserMode.next(currentMode.getOppositeValue())
            break
        case .Preference:
            let segueId = R.segue.accountViewController.toSelectPreferene.identifier
            appNavigator?.showAction(identifier: segueId)
        default:
            break
        }
    }

    func handleStaticContentAction(action: AccountAction) {
        if let staticContentType = AccountAction.toStaticContentType(action) {
            self.routeToStaticContent(staticContentType)
        }
    }
}

extension AccountViewModel: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(controller: MFMessageComposeViewController,
                                      didFinishWithResult result: MessageComposeResult) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

    var canInviteViaSms: Bool {
        return MFMessageComposeViewController.canSendText()
    }
}

extension AccountViewModel: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuMode.actions.count
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let action = menuMode.actions[indexPath.row]
        switch action {
        case .PushNotifications:
            return getSwitchActionCell(tableView, action: action)
        case .Preference:
            return getSelectActionCell(tableView, action: action)
        case .OpenToDate:
            return getSwitchActionCell(tableView, action: action)
        case .SwitchMode:
            return getActionCell(tableView, action: action)
        default:
            return getActionCell(tableView, action: action)
        }
    }

    func getActionCell(tableView: UITableView, action: AccountAction) -> UITableViewCell {
        let cellId = R.reuseIdentifier.actionTableViewCell.identifier
        let cellViewModel = ActionCellViewModel(action: action)
        guard let cell: ActionTableViewCell = tableView.getCell(cellViewModel, cellIdentifier: cellId)
            else { return UITableViewCell() }
        return cell
    }

     func getSwitchActionCell(tableView: UITableView, action: AccountAction) -> UITableViewCell {
        let cellId = R.reuseIdentifier.switchActionTableViewCell.identifier
        let viewModel = SwitchActionViewModel(action: action)
        guard let cell:SwitchActionTableViewCell = tableView.getCell(viewModel, cellIdentifier: cellId)
            else { return UITableViewCell() }
        return cell
    }

     func getSelectActionCell(tableView: UITableView, action: AccountAction) -> UITableViewCell {
        let cellId = R.reuseIdentifier.selectActionTableViewCell.identifier
        let viewModel = SelectActionViewModel(action: action, value: observablePreference)
        guard let cell: SelectActionTableViewCell = tableView.getCell(viewModel, cellIdentifier: cellId)
            else { return UITableViewCell() }
        return cell
    }
}

extension AccountViewModel {
    func loadCurrentUser() {
        userApi.currentUser {[unowned self] in
            self.observablePreference.next(
                UserPreference.getPreference(
                    AppController.shared.currentUser.value?.matchWithGender
                ).rawValue
            )
        }
    }
}

extension AccountViewModel: SelectValueDelegate {
    func valueSelected(value: String) {
        guard let preference = UserPreference(rawValue: value) else { return }
        let gender = preference.getGender()
        userApi.matchWith(gender) {
            self.observablePreference.next(value)
        }
    }
}

class AccountViewModel: NSObject, ViewModelProtocol {
    var appNavigator: AppNavigator?
    var staticContentApi: StaticContentApiProtocol = StaticContentApiController()
    var authApi: AuthApiProtocol = AuthApiController()
    var userApi: UserApiProtocol = UserApiController()
    let router = Router()

    var selectedStaticContent: AccountAction? = nil

    private var currentMenuMode: AccountMode = .General
    var menuMode: AccountMode {
        get {
            return currentMenuMode
        }
        set {
            currentMenuMode = newValue
            actionsTableView.reloadData()
        }
    }

    var observableAvatarImage: Observable<String?> = Observable(nil)
    var observableName: Observable<String?> = Observable("")
    var observableUserInfo: Observable<String?> = Observable("")
    var observablePreference: Observable<String?> = Observable("")

    var actionsTableView: UITableView

    init(actionTableView: UITableView, appNavigator: AppNavigator) {
        self.actionsTableView = actionTableView
        self.appNavigator = appNavigator
        AppController.shared.currentUserImage.bindTo(observableAvatarImage)
        super.init()
        AppController.shared.currentUserMode.observeNew(self.observeModeChanges)
        AppController.shared.currentUser.observe(self.observeUserChanges)
        loadCurrentUser()
    }

    func returnBack() {
        AppController.shared.leftMenu?.toggle("left")
    }

    func prepareForSegue(segue: UIStoryboardSegue) {
        guard let identifier = segue.identifier else { return }
        if identifier == R.segue.accountViewController.toSelectPreferene.identifier {
            guard let targetVc = segue.destinationViewController as? SelectValueTableViewController
                else { return }
            targetVc.title = AccountAction.Preference.rawValue
            targetVc.delegate = self
            let values = UserPreference.allValues.map { $0.rawValue }
            targetVc.values = values
        }
    }

    func observeModeChanges(mode: Mode) {
        self.actionsTableView.reloadData()
    }

    func observeUserChanges(user: PrivateUser?) {
        guard let newUser = user else { return }
        self.observableName.next(newUser.name)
        self.observableUserInfo.next(newUser.userInfo)
        self.actionsTableView.reloadData()
    }

    func handleInviteUser(type: StaticContentType) {
        guard canInviteViaSms else { return }
        let composeSms = MFMessageComposeViewController()
        composeSms.messageComposeDelegate = self
        staticContentApi.getWithType(type) {[weak self] (content) in
            composeSms.body = content
            self?.appNavigator?.presentVcAction(vc: composeSms)
        }
    }

    func logout() {
        authApi.logout {
            FBSDKLoginManager().logOut()
            AppController.shared.logOut()
        }
    }
}
