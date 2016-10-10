//
//  UserApiControllerMock.swift
//  3Degrees
//
//  Created by Gigster Developer on 6/2/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation
import ThreeDegreesClient

@testable import _Degrees

class UserApiControllerMock: UserApiProtocol {
    var api: ApiProtocol = BaseApiControllerMock()

    var isSingleValue: Bool!

    func currentUser(completion: () -> ()) {
        completion()
    }

    func updateUser(user: PrivateUser, completion: () -> ()) {
        completion()
    }

    func switchIsSingle(value: Bool, completion:() -> ()) {
        isSingleValue = value
        completion()
    }

    func matchWith(gender: PrivateUser.MatchWithGender?, completion: () -> ()) {
        completion()
    }

    func uploadImage(image: NSData, completion:(imageUrl: String?) ->()) {
        api.uploadImage(image) {(image, error, headers) in
            if error == nil {
                completion(imageUrl: image?.url)
            }
        }
    }

    func pushNotificationsValue(completion: (value: Bool) -> ()) {
        let currentCalendar = NSCalendar.currentCalendar()
        let components = currentCalendar.components([.Minute], fromDate: NSDate())
        completion(value: components.minute % 2 == 0)
    }

    func switchPushNotifications(deviceToken: String?, value: Bool, completion: () -> ()) {
        completion()
    }
}
