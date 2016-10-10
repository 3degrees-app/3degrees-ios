import Quick
import Nimble
import ThreeDegreesClient

@testable import _Degrees

class ContactViewModelSpec: QuickSpec {
    override func spec() {
        var contactViewModel: ContactViewModel!
        var contact: User!

        describe("user info for display") {
            beforeEach {
                contact = User()
                contact.firstName = "Paul"
                contact.lastName = "Gigster"
                contact.image = "https://placehold.it/10x10"
                contactViewModel = ContactViewModel(contact: contact, userType: MyNetworkTab.UsersType.Singles)
            }
            it("shows name") {
                let name = contactViewModel.name
                expect(name).to(equal(contact.fullName))
            }
            it("shows avatarUrl") {
                var avatar: String = contactViewModel.avatarUrl
                expect(avatar) == "\(contact.avatarUrl!)"
                (contactViewModel.contact as! User).image = nil
                avatar = contactViewModel.avatarUrl
                expect(avatar).to(beEmpty())
            }
        }
    }
}
