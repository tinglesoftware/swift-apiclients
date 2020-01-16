import XCTest
@testable import TingleApiClient

final class TingleApiClientTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(TingleApiClient().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
