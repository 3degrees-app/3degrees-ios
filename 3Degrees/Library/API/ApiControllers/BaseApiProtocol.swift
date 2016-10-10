//
//  BaseApiProtocol.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/31/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation
import SVProgressHUD
import ThreeDegreesClient

protocol BaseApiProtocol {
    var api: ApiProtocol { get set }

    func showActivityIndicator()
    func hideActivityIndicator()
    func showSuccessWithStatus(status: String)
    func showErrorWithStatus(status: String)

    func handleError(error: ErrorType?,
                     getErrorMessage:(ErrorType?) -> (String?)) -> Bool
}

extension BaseApiProtocol {
    func showActivityIndicator() {
        SVProgressHUD.show()
    }

    func hideActivityIndicator() {
        SVProgressHUD.popActivity()
    }

    func showSuccessWithStatus(status: String) {
        SVProgressHUD.showSuccessWithStatus(status)
    }

    func showErrorWithStatus(status: String) {
        SVProgressHUD.setMinimumDismissTimeInterval(3)
        SVProgressHUD.showErrorWithStatus(status)
    }

    func showUndefinedServerError() {
        showErrorWithStatus(R.string.localizable.undefinedNetworkError())
    }

    func handleError(error: ErrorType?,
                     getErrorMessage:(ErrorType?) -> (String?)) -> Bool {
        guard let message = getErrorMessage(error) else { return true }
        showErrorWithStatus(message)
        return false
    }
}
