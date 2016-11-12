//
//  ProfileViewModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 4/29/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation
import UIKit
import Bond
import ImagePicker
import ThreeDegreesClient

protocol ProfileViewModelProtocol: ViewModelProtocol {
    func avatarTapped()
    func editButtonTapped()

    var user: PrivateUser { get }
    var name: String { get }
    var location: String { get }
}

extension ProfileViewModel: ProfileViewModelProtocol {
    var name: String {
        return user.name
    }

    var location: String {
        return user.formattedLocation
    }

    func avatarTapped() {
        guard let picker = imagePickerController else { return }
        appNavigator?.presentVcAction(vc: picker)
    }

    func editButtonTapped() {
        updateImage {[unowned self] in
            self.userApi.updateUser(self.user) {[unowned self] in
                AppController.shared.currentUser.next(self.user)
                self.appNavigator?.popAction()
            }
        }
    }

    func updateImage(callback: () -> ()) {
        if let image = self.observableImage.value {
            let imageData = UIImageJPEGRepresentation(image, 0.0)
            guard let data = imageData else { return }
            self.userApi.uploadImage(data) {[unowned self] (imageUrl) in
                self.user.image = imageUrl
                AppController.shared.currentUserImage.next(imageUrl)
                callback()
            }
        } else {
            callback()
        }
    }

    func handleName(name: String) {
        let parts = name.characters.split { $0 == " " }.map(String.init)
        self.user.firstName = !parts.isEmpty ? parts[0] : ""
        self.user.lastName = parts.count > 1 ? parts[1] : ""
    }

    func handleGender(genderRawValue: String) {
        let gender = PrivateUser.Gender(rawValue: genderRawValue.lowercaseString)
        if let gender = gender {
            self.user.gender = gender
        }
    }

    func handleLocation(location: String) {
        let parts = location.characters.split { $0 == ","}.map(String.init)
        self.user.location = Location()
        self.user.location?.city = !parts.isEmpty ? parts[0].trimmed : ""
        self.user.location?.state = parts.count > 1 ? parts[1].trimmed : ""
        self.user.location?.country = parts.count > 2 ? parts[2].trimmed : ""
    }

    func handleBirthday(birthday: String) {
        guard let date = birthday.birthdayNSDate else { return }
        self.user.dob = date
    }

    func handleJobTitle(title: String?) {
        if self.user.employment != nil {
            self.user.employment?.title = title
        } else {
            let occupation = Employment()
            occupation.title = title
            self.user.employment? = occupation
        }
    }

    func handlePlaceOfWork(placeOfWork: String?) {
        if self.user.employment != nil {
            self.user.employment?.company = placeOfWork
        } else {
            let occupation = Employment()
            occupation.company = placeOfWork
            self.user.employment = occupation
        }
    }

    func handleDegree(degree: String?) {
        if self.user.education != nil {
            self.user.education?.degree = degree
        } else {
            let education = Education()
            education.degree = degree
            self.user.education = education
        }
    }

    func handleSchool(school: String?) {
        if self.user.education != nil {
            self.user.education?.school = school
        } else {
            let education = Education()
            education.school = school
            self.user.education = education
        }
    }
}

extension ProfileViewModel: ImagePickerDelegate {
    func wrapperDidPress(imagePicker: ImagePickerController,
                         images: [UIImage]) {

    }

    func doneButtonDidPress(imagePicker: ImagePickerController,
                            images: [UIImage]) {
        if !images.isEmpty {
            imagePickerController?.dismissViewControllerAnimated(true, completion: nil)

            if let image = images.first {
                observableImage.next(image)
            }
        }
    }

    func cancelButtonDidPress(imagePicker: ImagePickerController) {
        imagePickerController?.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension ProfileViewModel: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        updateTableViewHeight()
    }

    private func updateTableViewHeight() {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
}

extension ProfileViewModel: UITextFieldDelegate {
    func textField(textField: UITextField,
                   shouldChangeCharactersInRange range: NSRange,
                               replacementString string: String) -> Bool {
        var typingAttrs = textField.typingAttributes
        let shadow = NSShadow()
        shadow.shadowColor = Constants.Profile.TextShadowColor
        shadow.shadowOffset = CGSize()
        shadow.shadowBlurRadius = Constants.Profile.TextShadowRadius
        typingAttrs?[NSShadowAttributeName] = shadow
        textField.typingAttributes = typingAttrs
        textField.layer.masksToBounds = false
        return true
    }
}

extension ProfileViewModel: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(
        tableView: UITableView,
        estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
}

class ProfileViewModel: NSObject {
    var appNavigator: AppNavigator?
    var userApi: UserApiProtocol = UserApiController()

    let imagePickerController: ImagePickerController?
    let user: PrivateUser
    let tableView: UITableView
    let genderPickerDataSource: UIPickerViewDataSource
    let genderPickerDelegate: UIPickerViewDelegate
    let observableImageUrl: Observable<String?> = Observable(nil)
    let observableImage: Observable<UIImage?> = Observable(nil)

    init(user: PrivateUser,
         tableView: UITableView,
         appNavigator: AppNavigator,
         genderObservableValue: Observable<String?>) {
        self.appNavigator = appNavigator
        self.user = user
        self.tableView = tableView
        self.genderPickerDataSource = GenderPickerDataSource()
        self.genderPickerDelegate = GenderPickerDelegate(observableValue: genderObservableValue)
        Configuration.requestPermissionMessage = "To capture and use an in-app photo, 3degrees needs to access both Camera and Photos"
        self.imagePickerController = ImagePickerController()
        self.imagePickerController?.imageLimit = 1
        self.imagePickerController?.startOnFrontCamera = true
        super.init()
        self.imagePickerController?.delegate = self
        self.observableImageUrl.next(user.image)
    }
}
