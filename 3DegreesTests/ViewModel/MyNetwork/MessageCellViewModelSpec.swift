import Quick
import Nimble
import ThreeDegreesClient

@testable import _Degrees

class MessageCellViewModelSpec: QuickSpec {
    override func spec() {
        var viewModel:MessageCellViewModel!
        var message:Message!
        describe("message ownership") {
            beforeEach {
                let user = PrivateUser()
                user.username = "blablabla"
                AppController.shared.currentUser.next(user)
                message = Message()
                message.message = "bla"
                message.messageType = .Text
                message.recipient = user.username
                message.sender = "blah"
                message.timestamp = NSDate()
                viewModel = MessageCellViewModel(message: message)
            }
            it("returns who is owner of this message") {
                var isMine = viewModel.isMineMessage
                expect(isMine) == false
                let user = PrivateUser()
                user.username = "blah"
                AppController.shared.currentUser.next(user)
                isMine = viewModel.isMineMessage
                expect(isMine) == true
            }
        }
    }
}
