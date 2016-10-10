import Quick
import Nimble
import ThreeDegreesClient

@testable import _Degrees

class MyNetworkViewModelSpec: QuickSpec {
    override func spec() {
        var viewModel: MyNetworkViewModel!
        var tableView: UITableView!
        var router: RouterMock!
        var selectedTab: MyNetworkTab!
        var matchclickedDelegate:MatchingDelegateMock!
        var api:MyNetworkApiControllerMock!
        describe("table view delegate") {
            beforeEach {
                AppController.shared.currentUserMode.next(.Single)
                api = MyNetworkApiControllerMock()
                let vc = R.storyboard.myNetworkScene.myNetworkTableViewController()!
                tableView = vc.tableView
                router = RouterMock()
                matchclickedDelegate = MatchingDelegateMock()
                viewModel = MyNetworkViewModel(tableView: tableView, router: router)
                viewModel.matchClickedDelegate = matchclickedDelegate
                viewModel.myNetworkApi = api
                selectedTab = .First
                viewModel.selectedTab.next(selectedTab)
                tableView.delegate = viewModel
                tableView.dataSource = viewModel
            }
            it("returns header for only section") {
                let header = viewModel.tableView(viewModel.tableView,
                                                 viewForHeaderInSection: 0)
                expect(header?.superview).to(beAnInstanceOf(AddToNetworkTableViewCell))
            }
        }
    }
}
