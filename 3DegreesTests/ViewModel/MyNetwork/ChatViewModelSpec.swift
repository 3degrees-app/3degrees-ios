import Quick
import Nimble
import Rswift
import QuickLook
import ThreeDegreesClient

@testable import _Degrees

class ChatViewModelSpec: QuickSpec {
    override func spec() {
        var viewModel: ChatViewModel!
        var router: RouterMock!
        var api: MyNetworkApiControllerMock!
        var user: User!
        var tableView: UITableView!
        var imageMessage: Message!

        beforeSuite {
            user = User()
            user.username = "test_username"
            user.firstName = "first name"
            user.lastName = "last name"
            let vc = R.storyboard.myNetworkScene.chatViewController()!
            vc.interlocutor = user
            _ = vc.view
            tableView = vc.tableView!

            imageMessage = Message()
            imageMessage.timestamp = NSDate()
            imageMessage.recipient = user.username
            imageMessage.sender = "sender"
            imageMessage.messageType = .Image
            imageMessage.message = "https://placehold.it/500x500?text=Rock!"
        }

        describe("table view delegate") {
            beforeEach {
                router = RouterMock()
                api = MyNetworkApiControllerMock()
                viewModel = ChatViewModel(tableView: tableView, interlocutor: user, router: router)
                viewModel.myNetworkApi = api
                viewModel.router = router
                viewModel.tableView.delegate = viewModel
                viewModel.tableView.dataSource = viewModel
                imageMessage = Message()
                imageMessage.timestamp = NSDate()
                imageMessage.recipient = user.username
                imageMessage.sender = "sender"
                imageMessage.messageType = .Image
                imageMessage.message = "https://placehold.it/500x500?text=Rock!"
            }
            it("show preview controller for message with image on tap") {
                let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                viewModel.messages = [Message()]
                viewModel.tableView.reloadData()
                viewModel.tableView(tableView, didSelectRowAtIndexPath: indexPath)
                expect(router.presentedViewController).to(beFalse())
                viewModel.messages = [imageMessage]
                viewModel.tableView.reloadData()
                viewModel.tableView(tableView, didSelectRowAtIndexPath: indexPath)
                expect(router.presentedViewController).to(beTrue())
            }
        }
        describe("table view data source") {
            beforeEach {
                router = RouterMock()
                api = MyNetworkApiControllerMock()
                viewModel = ChatViewModel(tableView: tableView, interlocutor: user, router: router)
                viewModel.myNetworkApi = api
                viewModel.router = router
            }
            it("get cell for message") {
                let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                viewModel.messages = [Message()]
                var cell = viewModel.tableView(tableView, cellForRowAtIndexPath: indexPath)
                expect(cell).to(beAnInstanceOf(MessageTableViewCell))
                viewModel.messages = [imageMessage]
                cell = viewModel.tableView(tableView, cellForRowAtIndexPath: indexPath)
                expect(cell).to(beAnInstanceOf(ImageMessageTableViewCell))
            }
        }
        describe("image picker delegate") {
            beforeEach {
                router = RouterMock()
                api = MyNetworkApiControllerMock()
                let vc = R.storyboard.myNetworkScene.chatViewController()!
                vc.interlocutor = user
                _ = vc.view
                tableView = vc.tableView!
                tableView.delegate = viewModel
                tableView.dataSource = viewModel
                viewModel = ChatViewModel(tableView: tableView, interlocutor: user, router: router)
                viewModel.myNetworkApi = api
                viewModel.router = router
            }
            it("is done selecting image") {
                let image = R.image.defaultAvatarImage()!
                expect(viewModel.messages.count).to(equal(0))
                viewModel.doneButtonDidPress([image])
                expect(viewModel.messages.count).to(equal(1))
                expect(viewModel.messages.first!.recipient).to(equal(user.username!))
                expect(viewModel.messages.first!.messageType!).to(equal(Message.MessageType.Image))
            }
        }
        describe("loading existing and inserting new messages") {
            beforeEach {
                router = RouterMock()
                api = MyNetworkApiControllerMock()
                let vc = R.storyboard.myNetworkScene.chatViewController()!
                vc.interlocutor = user
                _ = vc.view
                tableView = vc.tableView!
                tableView.delegate = viewModel
                tableView.dataSource = viewModel
                viewModel = ChatViewModel(tableView: tableView, interlocutor: user, router: router)
                viewModel.myNetworkApi = api
                viewModel.router = router
            }
            it("loads existing messages") {
                viewModel.loadMessages(0, limit: 10)
                expect(viewModel.messages.count).to(equal(1))
                let baseApi = BaseApiControllerMock()
                baseApi.shoudFail = true
                api.api = baseApi
                viewModel.loadMessages(0, limit: 10)
                expect(viewModel.messages.count).to(equal(1))
            }
            it("clicks on send button") {
                let text = "message"
                viewModel.sendButtonPressed(text)
                expect(viewModel.messages.count).to(equal(1))
                expect(viewModel.messages.first!.message!).to(equal(text))
                let baseApi = BaseApiControllerMock()
                baseApi.shoudFail = true
                api.api = baseApi
                viewModel.sendButtonPressed(text)
                expect(viewModel.messages.count).to(equal(1))
            }
            it("insert message to the end of the table") {
                viewModel.insertMessage(imageMessage)
                expect(viewModel.messages).to(contain(imageMessage))
                expect(viewModel.tableView(tableView, numberOfRowsInSection: 0)).to(equal(1))
            }
        }
    }
}
