//
//  ProfileViewController.swift
//  3Degrees
//
//  Created by Gigster Developer on 4/30/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import FLTextView
import FBSDKLoginKit
import Kingfisher
import ImagePicker
import ThreeDegreesClient
import QuartzCore

class ProfileViewController: UITableViewController, ViewProtocol {
    private lazy var viewModel: ProfileViewModel = {
        let user = self.user ?? AppController.shared.currentUser.value!
        return ProfileViewModel(user: user,
                                tableView: self.tableView,
                                router: self,
                                genderObservableValue: self.genderTextField.bnd_text)
    }()

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var jobTitleTextView: FLTextView!
    @IBOutlet weak var placeOfWorkTextView: FLTextView!
    @IBOutlet weak var degreeTextView: FLTextView!
    @IBOutlet weak var schoolTextView: FLTextView!
    @IBOutlet weak var bioTextView: FLTextView!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var editAvatarButton: UIButton!
    @IBOutlet weak var avatarImageViewHeight: NSLayoutConstraint!

    @IBOutlet weak var importFromFbButton: UIButton!

    let editButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 23))
    let user: PrivateUser? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        applyDefaultStyle()
        initEditNavBarButton()
        configureBindings()
        initViewsWithCurrentValues()

        title = "Edit Profile"
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    func applyDefaultStyle() {
        tableView.backgroundColor = Constants.ViewOnBackground.Color
        tableView.preservesSuperviewLayoutMargins = false
        tableView.separatorColor = Constants.Profile.TableBordersColor
        tableView.delegate = viewModel

        avatarImageViewHeight.constant = UIScreen.mainScreen().bounds.height / 2

        nameField.layer.masksToBounds = false
        nameField.textColor = Constants.Profile.NameLabelColor
        nameField.dropShadow()

        jobTitleTextView.textColor = Constants.Profile.EditTitleColor
        degreeTextView.textColor = Constants.Profile.EditTitleColor
        bioTextView.textColor = Constants.Profile.EditTitleColor

        placeOfWorkTextView.textColor = Constants.Profile.EditSubtitleColor
        schoolTextView.textColor = Constants.Profile.EditSubtitleColor

        jobTitleTextView.removePadding()
        placeOfWorkTextView.removePadding()
        degreeTextView.removePadding()
        schoolTextView.removePadding()
        bioTextView.removePadding()
    }

    private func initEditNavBarButton() {
        var font = UIFont.systemFontOfSize(15, weight: UIFontWeightThin)
        if let f = UIFont(name: "HelveticaNeue", size: 17) {
            font = f
        }
        let attributes = NSAttributedString(
            string: "Save",
            attributes: [
                NSForegroundColorAttributeName: Constants.NavBar.TintColor,
                NSFontAttributeName: font,
            ]
        )
        editButton.setAttributedTitle(attributes, forState: .Normal)
        let navbarItem = UIBarButtonItem(customView: editButton)
        self.navigationItem.rightBarButtonItem = navbarItem
    }

    private func initViewsWithCurrentValues() {
        nameField.text = viewModel.name
        nameField.placeholder = R.string.localizable.namePlaceholder()
        if let education = viewModel.user.education {
            degreeTextView.bnd_text.next(education.degree)
            schoolTextView.bnd_text.next(education.school)
        }
        degreeTextView.placeholder = R.string.localizable.degreePlaceholder()
        schoolTextView.placeholder = R.string.localizable.schoolPlaceholder()
        if let occupation = viewModel.user.employment {
            jobTitleTextView.bnd_text.next(occupation.title)
            placeOfWorkTextView.bnd_text.next(occupation.company)
        }
        jobTitleTextView.placeholder = R.string.localizable.titlePlaceholder()
        placeOfWorkTextView.placeholder = R.string.localizable.employerPlaceholder()
        bioTextView.bnd_text.next(viewModel.user.bio)
        bioTextView.placeholder = R.string.localizable.bioPlaceholder()
        genderTextField.bnd_text.next(viewModel.user.gender?.rawValue.capitalizedString)
        genderTextField.placeholder = R.string.localizable.genderPlaceholder()
        birthdayTextField.bnd_text.next(viewModel.user.dob?.birthdayString)
        birthdayTextField.placeholder = R.string.localizable.birthdayPlaceholder()
        locationTextField.bnd_text.next(viewModel.location)
        locationTextField.placeholder = R.string.localizable.locationPlaceholder()
    }

    func configureBindings() {
        nameField.delegate = viewModel
        jobTitleTextView.delegate = viewModel
        placeOfWorkTextView.delegate = viewModel
        degreeTextView.delegate = viewModel
        schoolTextView.delegate = viewModel
        bioTextView.delegate = viewModel
        birthdayTextField.configureDatePickerInputView(viewModel.user.dob ?? NSDate())
        if let datePicker = birthdayTextField.inputView as? UIDatePicker {
            datePicker.bnd_date.observeNew {[unowned self] (date) in
                self.birthdayTextField.bnd_text.next(date.birthdayString)
            }
        }
        genderTextField.configurePickerView(
            viewModel.genderPickerDelegate,
            dataSource: viewModel.genderPickerDataSource
        )
        viewModel.observableImageUrl.observe {[unowned self] in
            self.avatarImageView.setAvatarImage($0, fullName: self.viewModel.name)
        }

        viewModel.observableImage.observe {[unowned self] in
            guard let image = $0 else { return }
            self.avatarImageView.image = image
        }

        editButton.bnd_tap.observe {[unowned self] () in
            self.viewModel.handleName(self.nameField.text ?? "")
            self.viewModel.handleJobTitle(self.jobTitleTextView.text)
            self.viewModel.handlePlaceOfWork(self.placeOfWorkTextView.text)
            self.viewModel.handleDegree(self.degreeTextView.text)
            self.viewModel.handleSchool(self.schoolTextView.text)
            self.viewModel.user.bio = self.bioTextView.text
            self.viewModel.handleGender(self.genderTextField.text ?? "")
            self.viewModel.handleBirthday(self.birthdayTextField.text ?? "")
            self.viewModel.handleLocation(self.locationTextField.text ?? "")

            self.viewModel.editButtonTapped()
        }

        configureEditAvatarButtons()
    }

    private func configureEditAvatarButtons() {
        if FBSDKAccessToken.currentAccessToken() == nil {
            importFromFbButton.bnd_hidden.next(true)
        } else {
            importFromFbButton.bnd_tap.observe {[unowned self] _ in
                let facebookUserIdString = FBSDKAccessToken.currentAccessToken().userID
                let urlString = "https://graph.facebook.com/\(facebookUserIdString)/picture?type=normal"
                let url = NSURL(string: urlString)!
                self.avatarImageView.kf_setImageWithURL(
                    url,
                    placeholderImage: nil,
                    optionsInfo: nil,
                    progressBlock: nil,
                    completionHandler: nil)
            }
        }

        editAvatarButton.bnd_tap.observe {[unowned self] _ in
            self.viewModel.avatarTapped()
        }
    }
}
