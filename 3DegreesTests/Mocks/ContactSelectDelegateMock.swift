//
//  ContactSelectDelegateMock.swift
//  3Degrees
//
//  Created by Gigster Developer on 6/6/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation

@testable import _Degrees

class ContactSelectDelegateMock: ContactSelectDelegate {
    var selectedContact: UserInfo? = nil

    func selected(contact: UserInfo) {
        selectedContact = contact
    }
}