import Quick
import Nimble
import ThreeDegreesClient

@testable import _Degrees

class DateProfileViewModelSpec: QuickSpec {
    override func spec() {
        var viewModel:DateProfileViewModel!
        var user: User!
        var selectedTab: MyNetworkTab!
        var router: RouterMock!
        var tableView: UITableView!
        describe("profile table view delegate") {
            beforeEach {
                user = User()
                user.username = "username"
                user.firstName = "first name"
                user.lastName = "last name"
                user.bio = "bio"
                let education = Education()
                education.degree = "Degree"
                education.school = "School"
                user.education = education
                let employment = Employment()
                employment.company = "Company"
                employment.title = "Title"
                user.employment = employment
                user.image = "https://placehold.it/500x500?text=AVATAR!"

                selectedTab = .Second
                router = RouterMock()
                let vc = R.storyboard.myNetworkScene.dateProfileViewController()!
                vc.selectedTab = selectedTab
                vc.user = user
                _ = vc.view
                tableView = vc.tableView
                viewModel = DateProfileViewModel(
                    user: user,
                    selectedTab: selectedTab,
                    tableView: tableView,
                    router: router
                )
            }
            it("gets row height") {
                let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                let height = viewModel.tableView(viewModel.tableView,
                                                 heightForRowAtIndexPath: indexPath)
                expect(height).to(equal(UITableViewAutomaticDimension))
            }
            it("gets estimated height for row") {
                let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                let estimatedHeight = viewModel.tableView(viewModel.tableView,
                                                          estimatedHeightForRowAtIndexPath: indexPath)
                expect(estimatedHeight) >= 90
            }
            it("selects row") {
//                AppController.shared.currentUserMode.next(Mode.Matchmaker)
//                let indexPath = NSIndexPath(forRow: 1, inSection: 0)
//                viewModel.tableView(viewModel.tableView, didSelectRowAtIndexPath: indexPath)
//                expect(router.showedVcWithId).to(beEmpty())
//                AppController.shared.currentUserMode.next(.Single)
//                viewModel.tableView(viewModel.tableView, didSelectRowAtIndexPath: indexPath)
//                let expected = R.segue.dateProfileViewController.toChatWithMatchmaker.identifier
//                expect(router.showedVcWithId).to(equal(expected))
            }
        }
        describe("profile table view data source") {
            beforeEach {
                user = User()
                user.username = "username"
                user.firstName = "first name"
                user.lastName = "last name"
                user.bio = "bio"
                let education = Education()
                education.degree = "Degree"
                education.school = "School"
                user.education = education
                let employment = Employment()
                employment.company = "Company"
                employment.title = "Title"
                user.employment = employment
                user.image = "https://placehold.it/500x500?text=AVATAR!"

                selectedTab = .Second
                router = RouterMock()
                let vc = R.storyboard.myNetworkScene.dateProfileViewController()!
                vc.selectedTab = selectedTab
                vc.user = user
                _ = vc.view
                tableView = vc.tableView
                viewModel = DateProfileViewModel(
                    user: user,
                    selectedTab: selectedTab,
                    tableView: tableView,
                    router: router
                )
            }
            it("gets number of sections") {
                let count = viewModel.numberOfSectionsInTableView(viewModel.tableView)
                expect(count) == 1
            }
            it("gets number of rows") {
                let count = viewModel.tableView(viewModel.tableView, numberOfRowsInSection: 0)
                expect(count) == DateProfileViewModel.TableRows.allForDate.count
            }
            it("gets cell") {
                AppController.shared.currentUserMode.next(Mode.Single)
                for (index, type) in DateProfileViewModel.TableRows.allForDate.enumerate() {
                    let ip = NSIndexPath(forRow: index, inSection: 0)
                    let cell = viewModel.tableView(viewModel.tableView, cellForRowAtIndexPath: ip)
                    switch type {
                    case DateProfileViewModel.TableRows.HeaderCell:
                        expect(cell).to(beAnInstanceOf(HeaderTableViewCell))
                        break
                    case DateProfileViewModel.TableRows.MatchmakerCell:
                        expect(cell).to(beAnInstanceOf(MatchmakerTableViewCell))
                        break
                    case DateProfileViewModel.TableRows.OccupationCell:
                        expect(cell).to(beAnInstanceOf(TwoFieldsTableViewCell))
                        break
                    case DateProfileViewModel.TableRows.EducationCell:
                        expect(cell).to(beAnInstanceOf(TwoFieldsTableViewCell))
                        break
                    case DateProfileViewModel.TableRows.BioCell:
                        expect(cell).to(beAnInstanceOf(OneFieldTableViewCell))
                        break
                    }
                }
            }
            it("goes to chat") {
                viewModel.goToChat()
                expect(router.showedVcWithId).to(equal(R.segue.dateProfileViewController.toChat.identifier))
            }
            it("matches user") {
                class MatchingDelegateMock: PersonForMatchingSelected {
                    var single: UserInfo? = nil
                    var matchmaker: UserInfo? = nil

                    func selectSingleForMatching(single: UserInfo) {
                        self.single = single
                    }

                    func selectMatchmakerForMatching(matchmaker: UserInfo) {
                        self.matchmaker = matchmaker
                    }
                }
                AppController.shared.currentUserMode.next(Mode.Single)
                var matchingDelegate = MatchingDelegateMock()
                viewModel.matchingDelegate = matchingDelegate
                viewModel.matchUser()
                expect(matchingDelegate.single?.username).to(equal(user.username))
                expect(matchingDelegate.matchmaker).to(beNil())
                AppController.shared.currentUserMode.next(Mode.Matchmaker)
                matchingDelegate = MatchingDelegateMock()
                viewModel.matchingDelegate = matchingDelegate
                viewModel.matchUser()
                expect(matchingDelegate.matchmaker?.username).to(equal(user.username))
                expect(matchingDelegate.single).to(beNil())
            }
        }
    }
}
