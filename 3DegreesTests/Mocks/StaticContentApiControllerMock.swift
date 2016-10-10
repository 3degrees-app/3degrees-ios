//
//  StaticContentApiControllerMock.swift
//  3Degrees
//
//  Created by Gigster Developer on 6/2/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation

@testable import _Degrees

class StaticContentApiControllerMock: StaticContentApiProtocol {
    var api: ApiProtocol = BaseApiControllerMock()

    func getWithType(contentType: StaticContentType, completion: (content: String) -> ()) {
        completion(content: "str")
    }
}
