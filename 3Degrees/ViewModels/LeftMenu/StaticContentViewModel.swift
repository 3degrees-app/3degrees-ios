//
//  StaticContentViewModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 6/1/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation
import Bond

struct StaticContentViewModel: ViewModelProtocol {
    var router: RoutingProtocol?
    var staticApi: StaticContentApiProtocol = StaticContentApiController()
    let contentType: LeftMenuAction
    let content: Observable<String> = Observable("")

    init(router: RoutingProtocol?, contentType: LeftMenuAction) {
        self.router = router
        self.contentType = contentType
    }

    func loadContent() {
        var type: StaticContentType
        switch contentType {
        case .ContactUs:
            type = .ContactUs
            break
        case .FAQ:
            type = .FAQ
            break
        case .PrivacyPolicy:
            type = .PrivacyPolicy
            break
        case .TermsOfService:
            type = .Tos
            break
        default:
            return
        }
        staticApi.getWithType(type) { (content) in
            self.content.next(content)
        }
    }
}
