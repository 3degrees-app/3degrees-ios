import Quick
import Nimble
import LKAlertController
import SVProgressHUD

@testable import _Degrees

class SignUpWithEmailViewModelSpec: QuickSpec {
    override func spec() {
        describe("Sign Up") {
            var viewModel: SignUpWithEmailViewModel!
            var mockRouter: RouterMock!

            context("form is in invalid state") {
                beforeEach {
                    mockRouter = RouterMock()
                    viewModel = SignUpWithEmailViewModel(router: mockRouter)
                    LKAlertController.overrideShowForTesting({ (style, title, message, actions, fields) in
                        mockRouter.presentedViewController = true
                    })

                    viewModel.birthday = "12/12/1912"
                    viewModel.email = "e@e.com"
                    viewModel.firstName = "First"
                    viewModel.lastName = "Last"
                    viewModel.gender = .Male
                    viewModel.password = "password"
                    viewModel.confirmPassword = "password"
                }
                it("is empty") {
                    viewModel.birthday = ""
                    viewModel.email = ""
                    viewModel.firstName = ""
                    viewModel.lastName = ""
                    viewModel.password = ""
                    viewModel.confirmPassword = ""

                    expect(viewModel.canSignUp).to(beFalse())
                    viewModel.signUp()
                    expect(mockRouter.presentedViewController).to(beTrue())
                }
                it("has different values in password and confirmation password fields") {
                    viewModel.confirmPassword = viewModel.confirmPassword! + "1"
                    expect(viewModel.canSignUp).to(beFalse())
                    viewModel.signUp()
                    expect(mockRouter.presentedViewController).to(beTrue())
                }
                it("has empty name") {
                    viewModel.firstName = ""
                    viewModel.lastName = ""
                    expect(viewModel.canSignUp).to(beFalse())
                    viewModel.signUp()
                    expect(mockRouter.presentedViewController).to(beTrue())
                }
                it("has empty birthday") {
                    viewModel.birthday = ""
                    expect(viewModel.canSignUp).to(beFalse())
                    viewModel.signUp()
                    expect(mockRouter.presentedViewController).to(beTrue())
                }
                it("has empty email") {
                    viewModel.email = ""
                    expect(viewModel.canSignUp).to(beFalse())
                    viewModel.signUp()
                    expect(mockRouter.presentedViewController).to(beTrue())
                }
                it("has empty password or confirm password") {
                    viewModel.password = ""
                    expect(viewModel.canSignUp).to(beFalse())
                    viewModel.signUp()
                    expect(mockRouter.presentedViewController).to(beTrue())
                }
            }

            context("form is valid, sign up can be processed") {
                var networkController: AuthApiControllerMock!
                beforeEach {
                    mockRouter = RouterMock()
                    viewModel = SignUpWithEmailViewModel(router: mockRouter)
                    networkController = AuthApiControllerMock()
                    viewModel.apiController = networkController
                    LKAlertController.overrideShowForTesting({ (style, title, message, actions, fields) in
                        mockRouter.presentedViewController = true
                    })
                    viewModel.birthday = "12/12/1912"
                    viewModel.email = "e@e.com"
                    viewModel.firstName = "First"
                    viewModel.lastName = "Last"
                    viewModel.gender = .Male
                    viewModel.password = "password"
                    viewModel.confirmPassword = "password"
                }
                it("should fail with network error") {
                    networkController.shouldError = true
                    viewModel.apiController = networkController
                    viewModel.signUp()
                    expect(mockRouter.presentedViewController).to(beFalse())
                }
                it("should process successfully") {
                    networkController.shouldError = false
                    viewModel.apiController = networkController
                    viewModel.signUp()
                    expect(mockRouter.presentedViewController).to(beFalse())
                    let segueId = R.segue.signUpWithEmailViewController.toModeSelection.identifier
                    expect(mockRouter.showedVcWithId).to(equal(segueId))
                }
            }
        }
    }
}
