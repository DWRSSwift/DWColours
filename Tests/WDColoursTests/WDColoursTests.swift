import XCTest
@testable import WDColours

final class WDColoursTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(WDColours().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
