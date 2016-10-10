//
//  AuthenticationViewController.swift
//  3Degrees
//
//  Created by Gigster Developer on 4/26/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import Bond
import FBSDKLoginKit

protocol SignUpModeViewControllerDelegate {
    func signUpWithEmail()
    func login()
}

class SignUpModeViewController: UIViewController, ViewProtocol {
    private lazy var viewModel: SignUpModeViewModel = {
        return SignUpModeViewModel (router: self)
    }()

    @IBOutlet weak var fbSignUpButton: UIButton!
    @IBOutlet weak var emailSignUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet var logoLabels: [UILabel]!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyAuthBackgroundImage()
        configureBindings()
        applyDefaultStyle()
    }

    func applyDefaultStyle() {
        self.view.backgroundColor = Constants.ViewOnBackground.Color

        self.emailSignUpButton.applyAuthButtonStyles()
        self.loginButton.applyAuthButtonStyles()
        self.fbSignUpButton.applyFacebookAuthButtonStyles()

        for label in logoLabels {
            label.applyAuthLabelStyle()
        }
    }

    func setDefaultValues() {
        self.fbSignUpButton.setTitle(R.string.localizable.signUpWithFacebookButtonTitle(),
                                     forState: .Normal)
        self.emailSignUpButton.setTitle(R.string.localizable.signUpWithEmailButtonTitle(),
                                        forState: .Normal)
        self.loginButton.setTitle(R.string.localizable.loginButtonTitle(), forState: .Normal)
    }

    internal func configureBindings() {
        self.fbSignUpButton.bnd_tap.observe {[unowned self] in
            self.viewModel.facebookLoginViewModel.loginFrom(self)
        }
        emailSignUpButton.bnd_tap.observe {[unowned self] () in
            self.viewModel.signUpWithEmail()
        }
        loginButton.bnd_tap.observe {[unowned self] () in
            self.viewModel.login()
        }
    }

}
