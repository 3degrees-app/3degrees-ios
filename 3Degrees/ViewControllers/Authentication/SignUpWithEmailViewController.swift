//
//  SignUpWithEmailViewController.swift
//  3Degrees
//
//  Created by Gigster Developer on 4/27/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import Bond
import ThreeDegreesClient

class SignUpWithEmailViewController: UITableViewController, ViewProtocol {

    lazy var viewModel: SignUpWithEmailViewModel = {[unowned self] in
        return SignUpWithEmailViewModel (appNavigator: self)
    }()

    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var birthdayField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet var signUpForm: [UITextField]!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var textFieldsBackViews: [UIView]!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyAuthBackgroundImage()
        applyDefaultStyle()
        configureBindings()
        initializeBirthdayInputSource()
        initializeGenderInputSource()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }

    func applyDefaultStyle() {
        signUpButton.applyAuthButtonStyles()
        signUpButton.setTitle(R.string.localizable.signUpButtonTitle(), forState: .Normal)
        logoLabel.applyAuthLabelStyle()
        firstNameField.applyAuthTextFieldStyles(R.string.localizable.firstNamePlaceholder())
        lastNameField.applyAuthTextFieldStyles(R.string.localizable.lastNamePlaceholder())
        emailField.applyAuthTextFieldStyles(R.string.localizable.emailPlaceholder())
        passwordField.applyAuthTextFieldStyles(R.string.localizable.passwordPlaceholder())
        confirmPasswordField.applyAuthTextFieldStyles(R.string.localizable.confirmPassPlaceholder())
        birthdayField.applyAuthTextFieldStyles(R.string.localizable.birthdayPlaceholder())
        genderField.applyAuthTextFieldStyles(R.string.localizable.genderPlaceholder())
        textFieldsBackViews.forEach { (view) in
            view.applyAuthTextFieldBackgroundStyle()
        }
    }

    private func initializeBirthdayInputSource() {
        self.birthdayField.configureDatePickerInputView()
        guard let datePicker = self.birthdayField.inputView as? UIDatePicker else { return }
        datePicker.bnd_date
                  .skip(1)
                  .map { $0.birthdayString }
                  .bindTo(self.birthdayField.bnd_text)
    }

    private func initializeGenderInputSource() {
        let pickerDelegate = viewModel.genderPickerDelegate
        let pickerDataSource = viewModel.genderPickerDataSource
        genderField.configurePickerView(pickerDelegate, dataSource: pickerDataSource)
        viewModel.genderObservableValue.observeNew {[unowned self] (text) in
            self.genderField.bnd_text.next(text)
        }
    }

    internal func configureBindings() {
        backButton.bnd_tap.observe {[unowned self] () in
            self.viewModel.backButtonPressed()
        }

        combineLatest(
            firstNameField.bnd_text,
            lastNameField.bnd_text,
            emailField.bnd_text,
            passwordField.bnd_text,
            confirmPasswordField.bnd_text,
            birthdayField.bnd_text,
            genderField.bnd_text)
            .map {[unowned self] (_, _, _, _, _, _, _) in
                return self.viewModel.canSignUp
        }.bindTo(signUpButton.bnd_enabled)

        firstNameField.bnd_text.observe {[unowned self] (name) in
            self.viewModel.firstName = name
        }
        lastNameField.bnd_text.observe {[unowned self] (name) in
            self.viewModel.lastName = name
        }
        emailField.bnd_text.observe {[unowned self] (email) in
            self.viewModel.email = email
        }
        passwordField.bnd_text.observe {[unowned self] (pass) in
            self.viewModel.password = pass
        }
        confirmPasswordField.bnd_text.observe {[unowned self] (confirmPass) in
            self.viewModel.confirmPassword = confirmPass
        }
        birthdayField.bnd_text.observe {[unowned self] (birthday) in
            self.viewModel.birthday = birthday
        }

        genderField.bnd_text.observe {[unowned self] (gender) in
            if let unwrappedGenderString = gender {
                guard let unwrappedGender = PrivateUser.Gender(
                    rawValue: unwrappedGenderString.lowercaseString)
                    else {
                        self.viewModel.gender = nil
                        return
                }
                self.viewModel.gender = unwrappedGender
            }
        }

        signUpButton.bnd_tap.observe {[unowned self] () in
            self.viewModel.signUp()
        }
    }
}
