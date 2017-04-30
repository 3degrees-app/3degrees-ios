//
//  AlertController+ForgotPass.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/20/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import LKAlertController

extension Alert {
    func configureForgotPassAlertController(viewModel: ForgotPasswordViewModel ) {
        var textField = UITextField()
        textField.keyboardType = .EmailAddress
        textField.autocapitalizationType = .None
        textField.placeholder = R.string.localizable.forgotPassTextFieldPlaceholder()
        self.addTextField(&textField)
        addAction(R.string.localizable.resetPassActionName(), style: .Default) {
            (action) in
            guard let tf = self.getAlertController().textFields?.first else { return }
            viewModel.resetPassword(tf.text!) { _ in 
                self.getAlertController()
                    .dismissViewControllerAnimated(true, completion: nil)
            }
        }
        addAction(R.string.localizable.cancel())
    }

    func configureResetPassAlertController(viewModel: ResetPasswordViewModel, completion: () -> ()) {
        var textField = UITextField()
        textField.secureTextEntry = true
        textField.placeholder = R.string.localizable.resetPassTextPlaceholder()
        self.addTextField(&textField)
        addAction(R.string.localizable.resetPassActionTitle(), style: .Default) {
            (action) in
            guard let tf = self.getAlertController().textFields?.first else { return }
            viewModel.resetPassword(tf.text!) {
                self.getAlertController()
                    .dismissViewControllerAnimated(true, completion: nil)
                completion()
            }
        }
        addAction(R.string.localizable.cancel())
    }
}
