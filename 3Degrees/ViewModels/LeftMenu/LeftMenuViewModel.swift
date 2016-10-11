//
//  LeftMenuViewModel.swift
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
import ThreeDegreesClient

extension LeftMenuViewModel: UITableViewDelegate {
    func tableView(tableView: UITableView,
                   heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch menuMode {
        case .General:
            handleGeneralAction(indexPath.row, actions: LeftMenuAction.generalActions)
            break
        case .About:
            handleAboutAction(indexPath.row, actions: LeftMenuAction.aboutActions)
            break
        case .Support:
            handleSupportAction(indexPath.row, actions: LeftMenuAction.supportActions)
            break
        }
    }

    func handleGeneralAction(index: Int, actions: [LeftMenuAction]) {
        let currentAction = actions[index]
        switch currentAction {
        case .EditProfile:
            let segueId = R.segue.leftMenuViewController.toEdit.identifier
            router?.showAction(identifier: segueId)
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
            let segueId = R.segue.leftMenuViewController.toSelectPreferene.identifier
            router?.showAction(identifier: segueId)
        default:
            break
        }
    }

    func handleSupportAction(index: Int, actions: [LeftMenuAction]) {
        switch actions[index] {
        case .FAQ:
            selectedStaticContent = .FAQ
            break
        case .ContactUs:
            selectedStaticContent = .ContactUs
            break
        default:
            break
        }
        router?.showAction(
            identifier: R.segue.leftMenuViewController.toStaticContent.identifier
        )
    }

    func handleAboutAction(index: Int, actions: [LeftMenuAction]) {
        switch actions[index] {
        case .TermsOfService:
            selectedStaticContent = .TermsOfService
            break
        case .PrivacyPolicy:
            selectedStaticContent = .PrivacyPolicy
        default:
            break
        }
        router?.showAction(
            identifier: R.segue.leftMenuViewController.toStaticContent.identifier
        )
    }
}

extension LeftMenuViewModel: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(controller: MFMessageComposeViewController,
                                      didFinishWithResult result: MessageComposeResult) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

    var canInviteViaSms: Bool {
        return MFMessageComposeViewController.canSendText()
    }
}

extension LeftMenuViewModel: UITableViewDataSource {
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

    func getActionCell(tableView: UITableView, action: LeftMenuAction) -> UITableViewCell {
        let cellId = R.reuseIdentifier.actionTableViewCell.identifier
        let cellViewModel = ActionCellViewModel(action: action)
        guard let cell: ActionTableViewCell = tableView.getCell(cellViewModel, cellIdentifier: cellId)
            else { return UITableViewCell() }
        return cell
    }

     func getSwitchActionCell(tableView: UITableView, action: LeftMenuAction) -> UITableViewCell {
        let cellId = R.reuseIdentifier.switchActionTableViewCell.identifier
        let viewModel = SwitchActionViewModel(action: action)
        guard let cell:SwitchActionTableViewCell = tableView.getCell(viewModel, cellIdentifier: cellId)
            else { return UITableViewCell() }
        return cell
    }

     func getSelectActionCell(tableView: UITableView, action: LeftMenuAction) -> UITableViewCell {
        let cellId = R.reuseIdentifier.selectActionTableViewCell.identifier
        let viewModel = SelectActionViewModel(action: action, value: observablePreference)
        guard let cell: SelectActionTableViewCell = tableView.getCell(viewModel, cellIdentifier: cellId)
            else { return UITableViewCell() }
        return cell
    }
}

extension LeftMenuViewModel {
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

extension LeftMenuViewModel: SelectValueDelegate {
    func valueSelected(value: String) {
        guard let preference = UserPreference(rawValue: value) else { return }
        let gender = preference.getGender()
        userApi.matchWith(gender) {
            self.observablePreference.next(value)
        }
    }
}

class LeftMenuViewModel: NSObject, ViewModelProtocol {
    var router: RoutingProtocol?
    var staticContentApi: StaticContentApiProtocol = StaticContentApiController()
    var authApi: AuthApiProtocol = AuthApiController()
    var userApi: UserApiProtocol = UserApiController()

    var selectedStaticContent: LeftMenuAction? = nil

    private var currentMenuMode: LeftMenuMode = .General
    var menuMode: LeftMenuMode {
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

    init(actionTableView: UITableView, router: RoutingProtocol) {
        self.actionsTableView = actionTableView
        self.router = router
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
        if identifier == R.segue.leftMenuViewController.toSelectPreferene.identifier {
            guard let targetVc = segue.destinationViewController as? SelectValueTableViewController
                else { return }
            targetVc.title = LeftMenuAction.Preference.rawValue
            targetVc.delegate = self
            let values = UserPreference.allValues.map { $0.rawValue }
            targetVc.values = values
        }
        if identifier == R.segue.leftMenuViewController.toStaticContent.identifier {
            guard let type = selectedStaticContent else { return }
            guard let targetVc = segue.destinationViewController as? StaticContentViewController
                else { return }
            targetVc.actionType = type
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
            self?.router?.presentVcAction(vc: composeSms)
        }
    }

    func logout() {
        authApi.logout {
            FBSDKLoginManager().logOut()
            AppController.shared.logOut()
        }
    }
}
