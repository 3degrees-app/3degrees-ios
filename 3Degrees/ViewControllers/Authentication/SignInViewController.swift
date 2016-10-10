//
//  SignInViewController.swift
//  3Degrees
//
//  Created by Gigster Developer on 4/28/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Bond
import Rswift

protocol SignInViewControllerProtocol {
    func signIn()
}

class SignInViewController: UIViewController, ViewProtocol {
    private lazy var viewModel: SignInViewModel = {[unowned self] in
        return SignInViewModel (router: self)
    }()

    @IBOutlet weak var fbSignInButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet var textFieldsBackViews: [UIView]!
    @IBOutlet weak var forgotPasswordButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyAuthBackgroundImage()
        configureBindings()
        setDefaultValues()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        applyDefaultStyle()
    }

    func applyDefaultStyle() {
        self.loginButton.applyAuthButtonStyles()
        self.logoLabel.applyAuthLabelStyle()
        self.fbSignInButton.applyFacebookAuthButtonStyles()
        self.textFieldsBackViews.forEach { (view) in
            view.applyAuthTextFieldBackgroundStyle()
        }
        self.emailTextField.applyAuthTextFieldStyles(R.string.localizable.emailPlaceholder())
        self.passwordField.applyAuthTextFieldStyles(R.string.localizable.passwordPlaceholder())
    }

    func setDefaultValues() {
        self.fbSignInButton.setTitle(R.string.localizable.signInWithFacebookButtonTitle(),
                                     forState: .Normal)
        self.loginButton.setTitle(R.string.localizable.loginButtonTitle(), forState: .Normal)
    }

    func configureBindings() {
        self.backButton.bnd_tap.observe {[unowned self] () in
            self.navigationController?.popViewControllerAnimated(true)
        }

        self.fbSignInButton.bnd_tap.observe {[unowned self] in
            self.viewModel.facebookLoginViewModel.loginFrom(self)
        }

        combineLatest(self.emailTextField.bnd_text, self.passwordField.bnd_text).map { (_, _) in
            return self.viewModel.canSignIn
        }.bindTo(self.loginButton.bnd_enabled)

        self.emailTextField.bnd_text.observe { (text) in
            self.viewModel.email = text
        }

        self.passwordField.bnd_text.observe { (text) in
            self.viewModel.password = text
        }

        self.loginButton.bnd_tap.observe {[unowned self] () in
            self.viewModel.signIn()
        }

        forgotPasswordButton.bnd_tap.observe {[unowned self]() in
            self.viewModel.showForgotPassDialog()
        }
    }
}
