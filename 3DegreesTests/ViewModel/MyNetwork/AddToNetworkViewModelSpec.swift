import Quick
import Nimble

@testable import _Degrees

class AddToNetworkViewModelSpec: QuickSpec {
    override func spec() {
        var viewModel: AddToNetworkViewModel!
        var router: RouterMock!
        describe("search on the server") {
            beforeEach {
                router = RouterMock()
                viewModel = AddToNetworkViewModel(router: router)
            }
            it("was tapped by user to search") {
                viewModel.tapped()
                expect(router.presentedViewController).to(beTrue())
            }
            it("was tapped by user but search controller is nil") {
                viewModel.searchController = nil
                viewModel.tapped()
                expect(router.presentedViewController).to(beFalse())
            }
            it("should get result controller") {
                let controller = viewModel.searchResultViewController
                expect(controller).to(beAnInstanceOf(ContactSearchTableViewController))
            }
            it("should get search controller with result controller") {
                let searchController = viewModel.searchController
                let searchResultController = viewModel.searchResultViewController
                expect(searchController?.searchResultsController).to(beAnInstanceOf(ContactSearchTableViewController))
                expect(searchController?.searchResultsUpdater).to(beIdenticalTo(searchResultController?.searchResultsUpdater))
                expect(searchController?.delegate).to(beIdenticalTo(viewModel))
            }
            it("should show postfix for contacts") {
                viewModel.userType.next(.Dates)
                expect(viewModel.postfix) == MyNetworkTab.UsersType.Matchmakers.postfix
                viewModel.userType.next(.Matchmakers)
                expect(viewModel.postfix) == MyNetworkTab.UsersType.Matchmakers.postfix
                viewModel.userType.next(.Singles)
                expect(viewModel.postfix) == MyNetworkTab.UsersType.Singles.postfix
            }
        }
        describe("search controller delegate") {
            beforeEach {
                router = RouterMock()
                viewModel = AddToNetworkViewModel(router: router)
            }
            it("will present search controller") {
                viewModel.willPresentSearchController(viewModel.searchController!)
                expect(router.navController?.navigationBar.translucent).to(beTrue())
            }
            it("will dismiss search controller") {
                viewModel.willDismissSearchController(viewModel.searchController!)
                expect(router.navController?.navigationBar.translucent).to(beFalse())
            }
        }

    }
}
