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
    var appNavigator: AppNavigator?
    var staticApi: StaticContentApiProtocol = StaticContentApiController()
    let contentType: AccountAction
    let content: Observable<String> = Observable("")

    init(appNavigator: AppNavigator?, contentType: AccountAction) {
        self.appNavigator = appNavigator
        self.contentType = contentType
    }

    func loadContent() {
        if let type = AccountAction.toStaticContentType(contentType) {
            staticApi.getWithType(type) { (content) in
                self.content.next(content)
            }
        }
    }
}
