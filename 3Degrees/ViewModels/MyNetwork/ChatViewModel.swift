//
//  ChatViewModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/17/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import QuickLook
import MobileCoreServices
import ImagePicker
import ThreeDegreesClient
import SwiftPaginator

extension ChatViewModel: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let message = messages[indexPath.row]
        if message.messageType == .Image {
            guard let imageCell = tableView.cellForRowAtIndexPath(indexPath) as? ImageMessageTableViewCell
                else { return }
            selectedImage = imageCell.mainView.image
            let quickLookVc = QLPreviewController()
            quickLookVc.dataSource = self
            self.router?.presentVcAction(vc: quickLookVc)
        }
    }
}

extension ChatViewModel: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(tableView: UITableView,
                   estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let viewModel = MessageCellViewModel(message: messages[indexPath.row])
        if messages[indexPath.row].messageType == Message.MessageType.Image {
            guard let cell: ImageMessageTableViewCell =
                tableView.getCell(viewModel, cellIdentifier: imageCellIdentifier)
                else { return UITableViewCell() }
            cell.transform = tableView.transform
            return cell
        } else {
            guard let cell: MessageTableViewCell =
                tableView.getCell(viewModel, cellIdentifier: messageCellIdentifier)
                else { return UITableViewCell() }
            cell.transform = tableView.transform
            return cell
        }
    }
}

extension ChatViewModel: QLPreviewControllerDataSource {
    func numberOfPreviewItemsInPreviewController(controller: QLPreviewController) -> Int {
        guard selectedImage != nil else { return 0 }
        return 1
    }

    func previewController(controller: QLPreviewController,
                           previewItemAtIndex index: Int) -> QLPreviewItem {
        let item: QLPreviewItem
        if let image = selectedImage {
            item = MessageImagePreviewItem(image: image)
        } else {
            item = MessageImagePreviewItem(image: UIImage())
        }
        return item
    }
}

extension ChatViewModel: ImagePickerDelegate {
    func wrapperDidPress(imagePicker: ImagePickerController,
                         images: [UIImage]) {

    }

    func doneButtonDidPress(imagePicker: ImagePickerController,
                            images: [UIImage]) {
        if !images.isEmpty {
            defer {
                imagePickerController.dismissViewControllerAnimated(true, completion: nil)
            }
            guard let username = interlocutor.username else { return }
            guard let image = images.first else { return }
            guard let imageData = UIImageJPEGRepresentation(image, 0) else { return }
            myNetworkApi.sendImage(username, image: imageData, completion: { (imageUrl) in
                let message = Message()
                message.timestamp = NSDate()
                message.message = imageUrl
                message.recipient = username
                message.sender = AppController.shared.currentUser.value?.username
                message.messageType = .Image
                self.insertMessage(message)
            })
        }
    }

    func cancelButtonDidPress(imagePicker: ImagePickerController) {
        imagePickerController.dismissViewControllerAnimated(true, completion: nil)
    }
}

class ChatViewModel: NSObject, ViewModelProtocol {

    let imageCellIdentifier = "ImageCell"
    let messageCellIdentifier = "MessageCell"

    var router: RoutingProtocol?
    var myNetworkApi: MyNetworkApiProtocol = MyNetworkApiController()
    let tableView: UITableView
    let interlocutor: UserInfo
    let imagePickerController: ImagePickerController
    var messages: [Message] = []
    var selectedImage: UIImage? = nil
    var paginator: Paginator<Message>? = nil

    init(tableView: UITableView, interlocutor: UserInfo, router: RoutingProtocol) {
        self.router = router
        self.tableView = tableView
        self.interlocutor = interlocutor
        self.tableView.registerClass(ImageMessageTableViewCell.classForCoder(),
                                     forCellReuseIdentifier: imageCellIdentifier)
        self.tableView.registerClass(MessageTableViewCell.classForCoder(),
                                     forCellReuseIdentifier: messageCellIdentifier)
        self.imagePickerController = ImagePickerController()
        self.imagePickerController.imageLimit = 1
        super.init()
        paginator = Paginator(
            pageSize: 30,
            fetchHandler: { (paginator, page, pageSize) in
                self.loadMessages(page - 1, limit: pageSize)
            },
            resultsHandler: { (paginator, messages) in
                self.handleHistoryMessages(messages)
        })

        paginator?.fetchFirstPage()
    }

    func loadMessages(page: Int, limit: Int) {
        guard let username = interlocutor.username else { return }
        myNetworkApi.getMessages(username, page: page, limit: limit) { (messages) in
            self.paginator?.receivedResults(messages, total: messages.count)
        }
    }

    func handleHistoryMessages(messages: [Message]) {
        if self.messages.count == messages.count {
            return
        }
        self.tableView.beginUpdates()
        messages.forEach { msg in
            let ip = NSIndexPath(forRow: self.messages.count, inSection: 0)
            self.tableView.insertRowsAtIndexPaths(
                [ip],
                withRowAnimation: .Top)
            self.messages.append(msg)
        }
        self.tableView.endUpdates()
    }

    func sendButtonPressed(text: String) {
        guard let username = interlocutor.username else { return }
        let message = Message()
        message.recipient = interlocutor.username
        message.message = text
        message.sender = AppController.shared.currentUser.value?.username
        message.timestamp = NSDate()
        message.messageType = .Text
        myNetworkApi.sendMessage(username, message: message) {
            self.insertMessage(message)
        }
    }

    func chooseImage() {
        imagePickerController.delegate = self
        router?.presentVcAction(vc: imagePickerController)
    }

    func insertMessage(message: Message) {
        paginator?.reset()
        paginator?.receivedResults(self.messages, total: self.messages.count)
        tableView.beginUpdates()
        messages.insert(message, atIndex: 0)
        let ip = NSIndexPath(forRow: 0, inSection: 0)

        tableView.insertRowsAtIndexPaths([ip], withRowAnimation: .Bottom)

        tableView.endUpdates()

        tableView.scrollToRowAtIndexPath(ip, atScrollPosition: .Top, animated: true)
    }
}

class MessageImagePreviewItem: NSObject, QLPreviewItem {
    var previewItemURL: NSURL

    init(image: UIImage) {
        let data: NSData? = UIImagePNGRepresentation(image)
        let fullPath:String = NSTemporaryDirectory().stringByAppendingString(String(image.hash) + ".png")
        data?.writeToFile(fullPath, atomically: false)
        previewItemURL = NSURL(fileURLWithPath: fullPath)
        super.init()
    }
}
