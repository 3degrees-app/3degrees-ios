import Quick
import Nimble

import ThreeDegreesClient

@testable import _Degrees

class DateProposalApiControllerSpec: QuickSpec {
    override func spec() {
        var api: DateProposalApiController!
        var baseApi: BaseApiControllerMock!
        describe("date proposal methods in case of error") {
            beforeEach {
                api = DateProposalApiController()
                baseApi = BaseApiControllerMock()
                baseApi.shoudFail = true
                api.api = baseApi
            }
            it("fetches suggested matches") {
                var success = false
                api.getDatesProposals(100, page: 0) { users in
                    success = true
                }
                expect(success) == false
            }
            it("accepts suggested match") {
                var success = false
                api.acceptDate("username") { shouldSuggestDates in
                    success = true
                }
                expect(success) == false
            }
            it("declines suggested match") {
                var success = false
                api.declineDate("username") {
                    success = true
                }
                expect(success) == false
            }
            it("suggests dates for date") {
                var success = false
                api.suggestDates("username", dates: [NSDate]()) {
                    success = true
                }
                expect(success) == false
            }
            it("accepts datetime for date") {
                var success = false
                api.acceptSuggestedDate("username", date: NSDate()) {
                    success = true
                }
                expect(success) == false
            }
        }
        describe("date proposal methods") {
            beforeEach {
                api = DateProposalApiController()
                baseApi = BaseApiControllerMock()
                baseApi.shoudFail = false
                api.api = baseApi
            }
            it("fetches suggested matches") {
                var success = false
                api.getDatesProposals(100, page: 0) { users in
                    success = true
                }
                expect(success) == true
            }
            it("accepts suggested match") {
                var success = false
                api.acceptDate("username") { shouldSuggestDate in
                    success = true
                }
                expect(success) == true
            }
            it("declines suggested match") {
                var success = false
                api.declineDate("username") {
                    success = true
                }
                expect(success) == true
            }
            it("suggests dates for date") {
                var success = false
                api.suggestDates("username", dates: [NSDate]()) {
                    success = true
                }
                expect(success) == true
            }
            it("accepts datetime for date") {
                var success = false
                api.acceptSuggestedDate("username", date: NSDate()) {
                    success = true
                }
                expect(success) == true
            }
        }
    }
}
