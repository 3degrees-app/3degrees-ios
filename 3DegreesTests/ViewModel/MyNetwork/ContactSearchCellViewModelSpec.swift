import Quick
import Nimble
import ThreeDegreesClient

@testable import _Degrees

class ContactSearchCellViewModelSpec: QuickSpec {
    override func spec() {
        var viewModel: ContactSearchCellViewModel!
        var api: MyNetworkApiControllerMock!
        var contact: UserInfo!
        var userWasIvited: ((UserInfo) -> ())!
        var userWasIvitedResult: Bool = false

        describe("search mode contact cell") {
            beforeEach {
                api = MyNetworkApiControllerMock()
                userWasIvitedResult = false
                userWasIvited = { user in
                    if contact.username == user.username {
                        userWasIvitedResult = true
                    } else {
                        userWasIvitedResult = false
                    }
                }
                let single = User()
                single.firstName = "first name"
                single.lastName = "last name"
                single.username = "username"
                contact = single
                viewModel = ContactSearchCellViewModel(contact: contact,
                    userType: MyNetworkTab.UsersType.Singles, invitedHandler: userWasIvited, mode: ContactSearchViewModel.SearchMode.Invite)
                viewModel.api = api
            }
            it("clicks invite button") {
                var completedSuccessfully = false
                viewModel.invite { (completion) in
                    completedSuccessfully = true
                    completion()
                }
                expect(completedSuccessfully).to(beTrue())
                expect(userWasIvitedResult).to(beTrue())
            }
        }
    }
}
