//
//  InviteNewViewModel.swift
//  3Degrees
//
//  Created by Ryan Martin on 3/27/17.
//

import Foundation
import UIKit
import Bond
import MessageUI
import ThreeDegreesClient

extension InviteNewViewModel: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(controller: MFMessageComposeViewController,
                                      didFinishWithResult result: MessageComposeResult) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    var canInviteViaSms: Bool {
        return MFMessageComposeViewController.canSendText()
    }
}


class InviteNewViewModel: UIButton, ViewModelProtocol {
    var appNavigator: AppNavigator? = nil
    var staticContentApi: StaticContentApiProtocol = StaticContentApiController()
    var userType: Observable<MyNetworkTab.UsersType> = Observable<MyNetworkTab.UsersType>(.Singles)

    required init(userType: Observable<MyNetworkTab.UsersType>, appNavigator: AppNavigator?) {
        super.init(frame: .zero)
        let attributedTitle = NSAttributedString(
            string: R.string.localizable.inviteNewButton(),
            attributes: [
                NSForegroundColorAttributeName: Constants.MyNetwork.InviteButtonTextColor,
                NSFontAttributeName: Constants.Fonts.SmallThin,
            ]
        )
        self.setAttributedTitle(attributedTitle, forState: .Normal)
        self.backgroundColor = Constants.MyNetwork.InviteButtonColor
        self.addTarget(self, action: #selector(InviteNewViewModel.btnclicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.appNavigator = appNavigator
        userType.bindTo(self.userType)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func btnclicked(sender: UIButton!) {
        guard canInviteViaSms else { return }
        let composeSms = MFMessageComposeViewController()
        composeSms.messageComposeDelegate = self
        staticContentApi.getWithType(self.userType.value.isSingles ? .InviteMessageSingle : .InviteMessageMM) {[weak self] (content) in
            composeSms.body = content.first!
            self?.appNavigator?.presentVcAction(vc: composeSms)
        }
    }
}