import Quick
import ThreeDegreesClient

@testable import _Degrees

class _DegreesTestsConfiguration: QuickConfiguration {
    override class func configure(configuration: Configuration) {
        configuration.beforeSuite {
            let privateUser = PrivateUser()
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
            //privateUser.gender = PrivateUser.Gender.Male
            let location = Location()
            location.city = "Foobar city"
            location.state = "FB"
            location.country = "Foobaria"
            privateUser.location = location
            let occupation = Employment()
            occupation.title = "fairytail teller"
            occupation.company = "Bar in fairyland"
            privateUser.employment = occupation
            AppController.shared.currentUser.next(privateUser)
            AppController.shared.currentUserMode.next(.Single)
        }
    }
}

