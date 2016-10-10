import Quick
import Nimble
import ThreeDegreesClient

@testable import _Degrees

class ContactSearchViewModelSpec: QuickSpec {
    override func spec() {
        var viewModel: ContactSearchViewModel!
        var router: RouterMock!
        var mode: ContactSearchViewModel.SearchMode!
        var api: MyNetworkApiControllerMock!

        describe("search result updates delegate") {
            beforeEach {
                router = RouterMock()
                mode = .Invite
                api = MyNetworkApiControllerMock()
                viewModel = ContactSearchViewModel(router: router, mode: mode)
                viewModel.myNetworkApi = api
            }
            it("handles updated search text") {
                let searchController = UISearchController(searchResultsController: UIViewController())
                searchController.searchBar.text = "hello"
                viewModel.updateSearchResultsForSearchController(searchController)
                expect(viewModel.searchText.value!).to(equal("hello"))
            }
        }

        describe("table view delegate") {
            var selectionDelegate: ContactSelectDelegateMock!

            beforeEach {
                router = RouterMock()
                mode = .Select
                api = MyNetworkApiControllerMock()
                viewModel = ContactSearchViewModel(router: router, mode: mode)
                viewModel.myNetworkApi = api
                selectionDelegate = ContactSelectDelegateMock()
                viewModel.selectionDelegate = selectionDelegate
                let contact = User()
                contact.username = "username"
                viewModel.people.append(contact)
            }
            it("does nothing for invite mode when cell is selected") {
                viewModel = ContactSearchViewModel(router: router, mode: .Invite)
                viewModel.tableView(UITableView(), didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
                expect(selectionDelegate.selectedContact).to(beNil())
            }
            it("invoke selection delegate for select mode when cell is selected") {
                viewModel.tableView(UITableView(), didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
                expect(selectionDelegate.selectedContact).toNot(beNil())
            }
        }
        describe("table view data source") {
            var selectionDelegate: ContactSelectDelegateMock!

            beforeEach {
                router = RouterMock()
                mode = .Select
                api = MyNetworkApiControllerMock()
                viewModel = ContactSearchViewModel(router: router, mode: mode)
                viewModel.myNetworkApi = api
                selectionDelegate = ContactSelectDelegateMock()
                viewModel.selectionDelegate = selectionDelegate
                let contact = User()
                contact.username = "username"
                viewModel.people.append(contact)
                let vc = R.storyboard.myNetworkScene.contactSearchTableViewController()
                viewModel.tableView = vc?.tableView
            }
            it("gets cell for contact") {
                let cell = viewModel.tableView(viewModel.tableView!, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
                expect(cell).to(beAnInstanceOf(ContactSearchTableViewCell))
            }
            it("gets number of rows") {
                let count = viewModel.tableView(viewModel.tableView!, numberOfRowsInSection: 0)
                expect(count).to(equal(1))
            }
            it("gets number of sections") {
                let count = viewModel.numberOfSectionsInTableView(viewModel.tableView!)
                expect(count).to(equal(1))
            }
        }
        describe("loading and updating people") {
            beforeEach {
                router = RouterMock()
                mode = .Select
                api = MyNetworkApiControllerMock()
                viewModel = ContactSearchViewModel(router: router, mode: mode)
                viewModel.myNetworkApi = api
                let contact = User()
                contact.username = "username"
                viewModel.people.append(contact)
                let vc = R.storyboard.myNetworkScene.contactSearchTableViewController()
                viewModel.tableView = vc?.tableView
                viewModel.tableView!.delegate = viewModel
                viewModel.tableView!.dataSource = viewModel
                viewModel.tableView!.reloadData()
            }
            it("removes all contacts") {
                viewModel.removeAllPeople()
                expect(viewModel.people).to(haveCount(0))
            }
            it("handles event that contact was just invited without network errors") {
                let notExistedContactInvited = User()
                notExistedContactInvited.username = "notexistedusername"
                viewModel.people.append(notExistedContactInvited)
                viewModel.tableView?.reloadData()
                viewModel.contactWasInvited(notExistedContactInvited)
                expect(viewModel.people).to(haveCount(1))
                let contact = viewModel.people.first!
                viewModel.contactWasInvited(contact)
                expect(viewModel.people).to(haveCount(0))
            }
            it("removes contact at index") {
                viewModel.removeInvitedUser(0)
                expect(viewModel.people).to(haveCount(0))
            }
            it("updates found people") {
                let contacts: [UserInfo] = (0...2).map {
                    let contact = User()
                    contact.username = "username" + String($0)
                    return contact
                }
                viewModel.updateFoundPeople(contacts)
                let expectedPeopleUsernames = viewModel.people.map { $0.username! }
                contacts.forEach {
                    let username: String = $0.username!
                    expect(expectedPeopleUsernames).to(contain(username))
                }
            }
            it("loads new people from the server with filter string") {
                viewModel.loadPeople("")
                expect(viewModel.people).to(beEmpty())
                viewModel.loadPeople("search")
                expect(viewModel.people).toNot(beEmpty())
                viewModel.loadPeople("")
                expect(viewModel.people).to(beEmpty())
            }
        }
    }
}
