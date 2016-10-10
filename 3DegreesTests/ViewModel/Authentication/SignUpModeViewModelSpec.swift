import Quick
import Nimble
import LKAlertController

@testable import _Degrees

class SignUpModeViewModelSpec: QuickSpec {
    override func spec() {
        describe("Facebook Login Delegate") {
            var signUpModeViewModel: SignUpModeViewModel!
            var mockRouter: RouterMock!
            var networkControllerMock: AuthApiControllerMock!

            beforeEach {
                mockRouter = RouterMock()
                signUpModeViewModel = SignUpModeViewModel(router: mockRouter)
                networkControllerMock = AuthApiControllerMock()
                signUpModeViewModel.apiController = networkControllerMock
                LKAlertController.overrideShowForTesting({
                    (style, title, message, actions, fields) in
                    mockRouter.presentedViewController = true
                })
            }
            it("completes with token error") {
                networkControllerMock.shouldError = false
                signUpModeViewModel.handleSuccessLogin("")
                expect(mockRouter.presentedViewController).to(equal(true))
            }
            it("completes with server error") {
                networkControllerMock.shouldError = true
                signUpModeViewModel.apiController = networkControllerMock
                signUpModeViewModel.handleSuccessLogin("correct_token")
                let expectedSegue = R.segue.signUpModeViewController.toModeSelection.identifier
                expect(mockRouter.showedVcWithId).toNot(equal(expectedSegue))
            }
            it("completes successfully") {
                signUpModeViewModel.handleSuccessLogin("correct_token")
                let expectedSegue = R.segue.signUpModeViewController.toModeSelection.identifier
                expect(mockRouter.showedVcWithId).to(equal(expectedSegue))
            }
            it("completes with facebook error") {
                let fbError = FacebookLoginError.Cancelled
                signUpModeViewModel.handleError(fbError)
                expect(mockRouter.presentedViewController).to(equal(true))
            }
        }
        describe("mode of authentication selected") {
            var mockRouter: RouterMock!
            var signUpModeViewModel: SignUpModeViewModel!
            beforeEach {
                mockRouter = RouterMock()
                signUpModeViewModel = SignUpModeViewModel(router: mockRouter)
            }
            it("should redirect to sign up with email screen") {
                signUpModeViewModel.signUpWithEmail()
                let segue = R.segue.signUpModeViewController.toSignUpWithEmail.identifier
                expect(mockRouter.showedVcWithId).to(equal(segue))
            }
            it("should redirect to login") {
                signUpModeViewModel.login()
                let segue = R.segue.signUpModeViewController.toLogin.identifier
                expect(mockRouter.showedVcWithId).to(equal(segue))
            }
        }
     }
}
