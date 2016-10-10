import Quick
import Nimble
import ThreeDegreesClient

@testable import _Degrees

class AuthApiControllerSpec: QuickSpec {
    override func spec() {
        var api: AuthApiController!
        var baseApi: BaseApiControllerMock!
        var success: Bool!
        describe("api for authentication in case of network error") {
            beforeEach {
                api = AuthApiController()
                baseApi = BaseApiControllerMock()
                baseApi.shoudFail = true
                api.api = baseApi
                success = false

            }
            it("should fail for login with facebook") {
                api.loginWithFacebook("") {
                    success = true
                }
                expect(success).to(beFalse())
            }
            it("should fail for login with email") {
                api.loginWithEmail("", password: "") {
                    success = true
                }
                expect(success).to(beFalse())
            }
            it("should fail for sign up with facebook") {
                api.signUp(nil) {
                    success = true
                }
                expect(success).to(beFalse())
            }
            it("should fail for sign up with email") {
                api.signUp(PrivateUser()) {
                    success = true
                }
                expect(success).to(beFalse())
            }
            it("should fail forgot pass") {
                api.forgotPassword("") {
                    success = true
                }
                expect(success).to(beFalse())
            }
            it("should not fail on log out") {
                api.logout {
                    success = true
                }
                expect(success).to(beTrue())
            }
        }
        describe("api for authentication in normal network state") {
            beforeEach {
                api = AuthApiController()
                baseApi = BaseApiControllerMock()
                api.api = baseApi
                success = false

            }
            it("should be successful for login with facebook") {
                api.loginWithFacebook("valid_token") {
                    success = true
                }
                expect(success).to(beTrue())
            }
            it("should be successful for sign up with email") {
                api.signUp(PrivateUser()) {
                    success = true
                }
                expect(success).to(beTrue())
            }
            it("should be successful forgot password") {
                api.forgotPassword("email") {
                    success = true
                }
                expect(success).to(beTrue())
            }
        }
        describe("error code translators") {
            beforeEach {
                api = AuthApiController()
                baseApi = BaseApiControllerMock()
                api.api = baseApi
                success = false

            }
        }
    }
}
