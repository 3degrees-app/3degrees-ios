//
//  MessageCellViewModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/17/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation
import ThreeDegreesClient

struct MessageCellViewModel: ViewModelProtocol {
    var appNavigator: AppNavigator? = nil
    let message: Message

    init(message: Message) {
        self.message = message
    }

    var isMineMessage: Bool {
        return AppController.shared.currentUser.value?.username != message.recipient
    }
}
