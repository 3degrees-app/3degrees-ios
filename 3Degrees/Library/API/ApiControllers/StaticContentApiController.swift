//
//  StaticContentApiController.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/31/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation
import ThreeDegreesClient

enum StaticContentType: String {
    case ContactUs = "contact-us"
    case Tos = "tos"
    case PrivacyPolicy = "privacy-policy"
    case FAQ = "faq"
    case InviteMessageMM = "invite.message.matchmaker"
    case InviteMessageSingle = "invite.message.single"
    case UnsupportedVersion = "unsupported-version"
    
    static let allPageContent = [ContactUs, Tos, PrivacyPolicy, FAQ, UnsupportedVersion]
}

protocol StaticContentApiProtocol: BaseApiProtocol {
    func getWithType(contentType: StaticContentType,
                     completion: (content: String) -> ())
}

struct StaticContentApiController: StaticContentApiProtocol {
    var api: ApiProtocol = ApiController()

    func getWithType(contentType: StaticContentType,
                     completion: (content: String) -> ()) {
        self.showActivityIndicator()
        api.staticContent(contentType.rawValue) { (data, error, headers) in
            guard self.handleError(error, getErrorMessage: self.getErrorMessage)
                else { return }
            guard let data = data?.content else { return }
            completion(content: data)
            self.hideActivityIndicator()
        }
    }

    func getErrorMessage(error: ErrorType?) -> String? {
        if let error = error as? ErrorResponse {
            switch error {
            case ErrorResponse.contentContentTypeGet404(let e): return e.message
            default:
                return ""
            }
        }
        return nil
    }
}
