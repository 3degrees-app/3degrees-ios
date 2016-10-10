//
//  StaticContentViewModelSpec.swift
//  3Degrees
//
//  Created by Gigster Developer on 6/2/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Quick
import Nimble

@testable import _Degrees

class StaticContentViewModelSpec: QuickSpec {
    override func spec() {
        var viewModel: StaticContentViewModel!
        var staticContentApi: StaticContentApiControllerMock!
        describe("loading content") {
            beforeEach {
                viewModel = StaticContentViewModel(router: nil, contentType: .FAQ)
                staticContentApi = StaticContentApiControllerMock()
                viewModel.staticApi = staticContentApi
            }
            it("starts loading faq") {
                var content = ""
                viewModel.content.observeNew { content = $0 }
                viewModel.loadContent()
                expect(content).to(equal("str"))
            }
            it("starts loading undefined content type") {
                viewModel = StaticContentViewModel(router: nil, contentType: .ContactUs)
                viewModel.loadContent()
                expect(viewModel.content.value).to(equal(""))
            }
        }
    }
}
