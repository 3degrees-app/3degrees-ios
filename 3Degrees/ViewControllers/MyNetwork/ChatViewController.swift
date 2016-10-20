//
//  ChatViewController.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/16/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import SlackTextViewController

class ChatViewController: SLKTextViewController, ViewProtocol {
    private lazy var viewModel: ChatViewModel = {[unowned self] in
        return ChatViewModel(tableView: self.tableView!, interlocutor: self.interlocutor!, router: self)
    }()

    var interlocutor: UserInfo? = nil
    private lazy var avatarImage: UIImageView = {[unowned self] in
        let avatar = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        avatar.contentMode = .ScaleAspectFill
        avatar.layer.cornerRadius = avatar.frame.height / 2
        avatar.layer.masksToBounds = true
        avatar.setAvatarImage(self.interlocutor?.avatarUrl,
                              fullName: self.interlocutor?.fullName ?? "")
        return avatar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView?.separatorColor = UIColor.clearColor()
        applyDefaultStyle()
        configureBindings()
        title = interlocutor?.fullName
    }

    override class func tableViewStyleForCoder(decoder: NSCoder) -> UITableViewStyle {
        return .Plain
    }

    func applyDefaultStyle() {

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: avatarImage)
        self.tableView?.backgroundColor = Constants.ViewOnBackground.Color
        self.textView.keyboardType = .Default
        self.tableView?.separatorColor = UIColor.clearColor()

        self.leftButton.setImage(UIImage(named: "addFile"), forState: .Normal)
        self.leftButton.tintColor = Constants.Chat.MyMessageDateTimeColor
        self.rightButton.tintColor = Constants.Chat.MyMessageDateTimeColor
        self.inverted = true
    }

    func configureBindings() {
        self.tableView?.delegate = viewModel
        self.tableView?.dataSource = viewModel
        self.registerPrefixesForAutoCompletion([""])
    }

    override func didPressLeftButton(sender: AnyObject?) {
        viewModel.chooseImage()
        super.didPressLeftButton(sender)
    }

    override func didPressRightButton(sender: AnyObject?) {
        self.textView.refreshFirstResponder()
        viewModel.sendButtonPressed(self.textView.text)
        super.didPressRightButton(sender)
    }
}
