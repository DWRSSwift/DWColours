import XCTest
@testable import DWColours

private extension String {
    static func randomAlphaNumeric(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}

final class WDColoursTests: XCTestCase {
    struct HexValue {
        let hexValue: String
        let rgbValue: [UInt8]
        var alpha: Double = 1.0
    }
    
    let validHexes = [
        HexValue(hexValue: "fc3503", rgbValue: [252, 53, 3]),
        HexValue(hexValue: "52fc03", rgbValue: [82, 252, 3]),
        HexValue(hexValue: "03fcba", rgbValue: [3, 252, 186]),
        HexValue(hexValue: "0380fc", rgbValue: [3, 128, 252]),
        HexValue(hexValue: "52fc03", rgbValue: [82, 252, 3]),
        HexValue(hexValue: "7b03fc", rgbValue: [123, 3, 252]),
        HexValue(hexValue: "e703fc", rgbValue: [231, 3, 252]),
        HexValue(hexValue: "fc0303", rgbValue: [252, 3, 3]),
    ]
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testHexStringToBytesValidString() throws {
        try validHexes.forEach {
            let hexBytes = try hexStringToBytes($0.hexValue)
            XCTAssertEqual(hexBytes, $0.rgbValue)
        }
    }
    
    func testHexStringToBytesThrowsOnInvalidString() {
        XCTAssertThrowsError(try hexStringToBytes("fc350"), "Should throw badcount") { error in
            XCTAssertEqual(error as! HexConversionError, HexConversionError.badCount(count: 5))
        }
        XCTAssertThrowsError(try hexStringToBytes("fc😊503"), "Should throw badcount") { error in
            XCTAssertEqual(error as! HexConversionError, HexConversionError.badSubstring(string: "😊5"))
        }
    }
    
    func testCustomColorFromValidString() throws {
        try validHexes.forEach {
            let colour = try RGBColour(fromHex: $0.hexValue)
            XCTAssertNotNil(colour)
            let uiColour = UIColor(colour!.color!)
            var r = CGFloat()
            var g = CGFloat()
            var b = CGFloat()
            var a = CGFloat()
            uiColour.getRed(&r, green: &g, blue: &b, alpha: &a)
            XCTAssertEqual(UInt8(r * 255), $0.rgbValue[0], accuracy: 1, "Red value did not match")
            XCTAssertEqual(UInt8(g * 255), $0.rgbValue[1], accuracy: 1, "Green value did not match")
            XCTAssertEqual(UInt8(b * 255), $0.rgbValue[2], accuracy: 1, "Blue value did not match")
            XCTAssertEqual(a, 1.0, "Alpha did not match expectation")
        }
    }
    
    func testCustomColorFromThreeDigitString() throws {
        let value1 = HexValue(hexValue: "FA7", rgbValue: [255, 170, 118])
        var value2 = HexValue(hexValue: "FA7F", rgbValue: [255, 170, 118])
        value2.alpha = 0.5
        try [value1, value2].forEach {
            let colour = try RGBColour(fromHex: $0.hexValue)
            XCTAssertNotNil(colour)
            let uiColour = UIColor(colour!.color!)
            var r = CGFloat()
            var g = CGFloat()
            var b = CGFloat()
            var a = CGFloat()
            uiColour.getRed(&r, green: &g, blue: &b, alpha: &a)
            XCTAssertEqual(UInt8(r * 255), $0.rgbValue[0], accuracy: 1, "")
            XCTAssertEqual(UInt8(g * 255), $0.rgbValue[1], accuracy: 1, "")
            XCTAssertEqual(UInt8(b * 255), $0.rgbValue[2], accuracy: 1, "")
            XCTAssertEqual(a, 1.0, "Alpha did not match expectation")
        }
    }
    
    func testCustomColorNilForTooLongString() {
        XCTAssertNil(try RGBColour(fromHex: String.randomAlphaNumeric(length: 5)), "Should reject 5 char string")
        XCTAssertNil(try RGBColour(fromHex: String.randomAlphaNumeric(length: 7)), "Should reject 7 char string")
        XCTAssertNil(try RGBColour(fromHex: String.randomAlphaNumeric(length: 9)), "Should reject 9 char string")
    }
    
    func testCustomColorNilForTooShortString() {
        XCTAssertNil(try RGBColour(fromHex: String.randomAlphaNumeric(length: 1)), "Should reject 1 char string")
        XCTAssertNil(try RGBColour(fromHex: String.randomAlphaNumeric(length: 2)), "Should reject 2 char string")
    }
    
    func testCustomColorNilForInvalidString() {
        XCTAssertNil(try RGBColour(fromHex: "fc😊503"))
    }
    
    func testPerformanceHexStringToBytes() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            for _ in 0...7500 {
                try! validHexes.forEach {
                    XCTAssertNoThrow(try hexStringToBytes($0.hexValue))
                }
            }
        }
    }
    
    func testPerformanceCustomColorFromHex() throws {
        self.measure {
            // Put the code you want to measure the time of here.
            for _ in 0...2000 {
                for hex in validHexes {
                    XCTAssertNotNil(try! RGBColour(fromHex: hex.hexValue))
                }
            }
        }
    }
    
    func testPerformanceHexRegex() {
        self.measure {
            // Put the code you want to measure the time of here.
            for _ in 0...2000 {
                for hex in validHexes {
                    let colour = extractColourComponents(from: hex.hexValue)
                    XCTAssertNotNil(colour)
                }
            }
        }
    }
    
    static var allTests = [
        ("testHexStringToBytesValidString", testHexStringToBytesValidString),
        ("testHexStringToBytesThrowsOnInvalidString", testHexStringToBytesThrowsOnInvalidString),
        ("testCustomColorFromValidString", testCustomColorFromValidString),
        ("testCustomColorFromThreeDigitString", testCustomColorFromThreeDigitString),
        ("testCustomColorNilForTooLongString", testCustomColorNilForTooLongString),
        ("testCustomColorNilForTooShortString", testCustomColorNilForTooShortString),
        ("testCustomColorNilForInvalidString", testCustomColorNilForInvalidString),
        ("testPerformanceHexStringToBytes", testPerformanceHexStringToBytes),
        ("testPerformanceCustomColorFromHex", testPerformanceCustomColorFromHex),
        ("testPerformanceHexRegex", testPerformanceHexRegex)
    ]
}
