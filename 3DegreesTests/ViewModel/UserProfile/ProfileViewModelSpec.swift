//
//  ProfileViewModelSpec.swift
//  3Degrees
//
//  Created by Gigster Developer on 6/3/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Quick
import Nimble
import Bond
import ThreeDegreesClient

@testable import _Degrees

class ProfileViewModelSpec: QuickSpec {
    override func spec() {
        var viewModel: ProfileViewModel!
        var tableView: UITableView!
        var router: RouterMock!
        var genderObservableValue: Observable<String?>!
        var privateUser: PrivateUser!
        var userApi: UserApiControllerMock!

        beforeSuite { 
            privateUser = PrivateUser()
            privateUser.firstName = "First Name"
            privateUser.lastName = "Last Name"
            privateUser.username = "username"
            privateUser.emailAddress = "test@test.com"
            privateUser.dob = NSDate()
            privateUser.bio = "Bla bla bla, bla bla, bla"
            let education = Education()
            education.degree = "Bachalor degree in Blabla science"
            education.school = "University of Blabla"
            privateUser.education = education
            privateUser.gender = PrivateUser.Gender.Male
            let location = Location()
            location.city = "Foobar city"
            location.state = "FB"
            location.country = "Foobaria"
            privateUser.location = location
            let occupation = Employment()
            occupation.title = "fairytail teller"
            occupation.company = "Bar in fairyland"
            privateUser.employment = occupation

            let vc = R.storyboard.userProfileScene.profileViewController()!
            _ = vc.view
            tableView = vc.tableView

            genderObservableValue = Observable("")
        }

        describe("profile view model protocol") {
            beforeEach {
                router = RouterMock()
                viewModel = ProfileViewModel(user: privateUser, tableView: tableView, router: router, genderObservableValue: genderObservableValue)
                userApi = UserApiControllerMock()
                viewModel.userApi = userApi
            }
            it("gets name") {
                expect(viewModel.name).to(equal(privateUser.name))
            }

            it("gets location") {
                expect(viewModel.location).to(equal(privateUser.formattedLocation))
            }

            it("clicks on avatar") {
                viewModel.avatarTapped()
                expect(router.presentedViewController).to(beTrue())
            }
            it("clicks on edit button") {
                AppController.shared.currentUser.next(privateUser)
                viewModel.user.bio = privateUser.bio! + "blabla"
                let oldUser = AppController.shared.currentUser.value!
                viewModel.editButtonTapped()
                let newUser = AppController.shared.currentUser.value!
                expect(router.poped).to(beTrue())
                expect(newUser.bio).to(equal(oldUser.bio))
            }
            it("is called to handle name") {
                viewModel.handleName("")
                expect(viewModel.user.firstName).to(equal(""))
                expect(viewModel.user.lastName).to(equal(""))
                viewModel.handleName("t t")
                expect(viewModel.user.firstName).to(equal("t"))
                expect(viewModel.user.lastName).to(equal("t"))
                viewModel.handleName("t")
                expect(viewModel.user.firstName).to(equal("t"))
                expect(viewModel.user.lastName).to(equal(""))
            }
            it("is called to handle gender") {
                let oldGenderValue = privateUser.gender?.rawValue
                viewModel.handleGender("")
                expect(viewModel.user.gender?.rawValue).to(equal(oldGenderValue))
                viewModel.handleGender(PrivateUser.Gender.Female.rawValue)
                expect(viewModel.user.gender?.rawValue).to(equal(PrivateUser.Gender.Female.rawValue))
                viewModel.handleGender(PrivateUser.Gender.Male.rawValue)
                expect(viewModel.user.gender?.rawValue).to(equal(PrivateUser.Gender.Male.rawValue))
            }
            it("is called to handle location") {
                viewModel.handleLocation("")
                expect(viewModel.user.location?.state).to(equal(""))
                expect(viewModel.user.location?.city).to(equal(""))
                expect(viewModel.user.location?.country).to(equal(""))
                viewModel.handleLocation("city")
                expect(viewModel.user.location?.state).to(equal(""))
                expect(viewModel.user.location?.city).to(equal("city"))
                expect(viewModel.user.location?.country).to(equal(""))
                viewModel.handleLocation("city, state")
                expect(viewModel.user.location?.state).to(equal("state"))
                expect(viewModel.user.location?.city).to(equal("city"))
                expect(viewModel.user.location?.country).to(equal(""))
                viewModel.handleLocation("city, state, country")
                expect(viewModel.user.location?.state).to(equal("state"))
                expect(viewModel.user.location?.city).to(equal("city"))
                expect(viewModel.user.location?.country).to(equal("country"))
            }
            it("is called to handle birthday") {
                let oldDob = privateUser.dob!
                viewModel.handleBirthday("")
                expect(viewModel.user.dob).to(equal(oldDob))
                viewModel.handleBirthday("06")
                expect(viewModel.user.dob).to(equal(oldDob))
                viewModel.handleBirthday("06/02/2014")
                expect(viewModel.user.dob?.birthdayString).to(equal("06/02/2014"))
            }
            it("is called to handle job title") {
                viewModel.handleJobTitle("")
                expect(viewModel.user.employment?.title).to(equal(""))
                viewModel.handleJobTitle("title")
                expect(viewModel.user.employment?.title).to(equal("title"))
            }
            it("is called to handle place of work") {
                viewModel.handlePlaceOfWork("")
                expect(viewModel.user.employment?.company).to(equal(""))
                viewModel.handlePlaceOfWork("company")
                expect(viewModel.user.employment?.company).to(equal("company"))
            }
            it("is called to handle degree") {
                viewModel.handleDegree("")
                expect(viewModel.user.education?.degree).to(equal(""))
                viewModel.handleDegree("degree")
                expect(viewModel.user.education?.degree).to(equal("degree"))
            }
            it("is called to handle school") {
                viewModel.handleSchool("")
                expect(viewModel.user.education?.school).to(equal(""))
                viewModel.handleSchool("school")
                expect(viewModel.user.education?.school).to(equal("school"))
            }
        }
        describe("image picker delegate") { 
            beforeEach {
                router = RouterMock()
                viewModel = ProfileViewModel(user: privateUser, tableView: tableView, router: router, genderObservableValue: genderObservableValue)
                userApi = UserApiControllerMock()
                viewModel.userApi = userApi
            }
            it("clicks done selection") {
                let image = R.image.defaultAvatarImage()!
                viewModel.doneButtonDidPress([image])
                expect(viewModel.observableImage.value).toNot(beNil())
            }
        }
    }
}
