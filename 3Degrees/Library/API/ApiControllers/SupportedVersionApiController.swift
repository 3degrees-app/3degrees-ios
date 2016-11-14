//
//  SupportedVersionApiController.swift
//  3Degrees
//
//  Created by Ryan Martin on 11/1/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation
import ThreeDegreesClient

protocol SupportedVersionApiProtocol: BaseApiProtocol {
    func checkVersion(version: String,
                     completion: (isActive: Bool) -> ())
}

struct SupportedVersionApiController: SupportedVersionApiProtocol {
    var api: ApiProtocol = ApiController()
    
    func checkVersion(version: String,
                      completion: (isActive: Bool) -> ()) {
        self.showActivityIndicator()
        api.supportedVersion(version) { (data, error, headers) in
            if let error = error as? ErrorResponse {
                switch error {
                case ErrorResponse.supportedVersionsVersionGet404(_): completion(isActive: false)
                default:
                    completion(isActive: true)
                }
            }
        }
    }
    
    func getErrorMessage(error: ErrorType?) -> String? {
        if let error = error as? ErrorResponse {
            switch error {
            case ErrorResponse.supportedVersionsVersionGet404(let e): return e.message
            default:
                return ""
            }
        }
        return nil
    }
}
