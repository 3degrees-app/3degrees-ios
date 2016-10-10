import Quick
import Nimble
import LKAlertController

@testable import _Degrees

class ForgotPasswordViewModelSpec: QuickSpec {
    override func spec() {
        describe("reset password") {
            var viewModel: ForgotPasswordViewModel!
            var networkController: AuthApiControllerMock!
            var completedSuccessfully: Bool!
            beforeEach {
                viewModel = ForgotPasswordViewModel()
                networkController = AuthApiControllerMock()
                viewModel.apiController = networkController
                completedSuccessfully = false
            }
            it("should fail with empty email") {
                viewModel.resetPassword("") {
                    completedSuccessfully = true
                }
                expect(completedSuccessfully).to(beFalsy())
            }
            it("should fail with network error") {
                networkController.shouldError = true
                viewModel.apiController = networkController
                viewModel.resetPassword("email@email.com") {
                    completedSuccessfully = true
                }
                expect(completedSuccessfully).to(beFalsy())
            }
            it("should completes successfully") {
                viewModel.resetPassword("correct@email.com") {
                    completedSuccessfully = true
                }
                expect(completedSuccessfully).to(beTrue())
            }
        }
    }
}
