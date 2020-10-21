//
//  File.swift
//  
//
//  Created by David Stephens on 21/10/2020.
//

import Foundation

let hexRegex = try! NSRegularExpression(pattern: "^#?(?<rgba>[a-f0-9]{3,8})$", options: .caseInsensitive)

/**
 Splits a hex string into RGB and Alpha components
 
 This string must be 3, 4, 6 or 8 characters:
 * 3 characters will be interpreted as a "shorthand" hex triplet with an alpha of 1.0.
 * 4 characters will be interpreted as a "shorthand" hex triplet with a "shorthand" alpha.
 * 6 characters will be interpreted as a "full" hex string with an alpha of 1.0.
 * 8 characters will be interepreted as a hex string with a "full" alpha.
 
 - Parameter fromHex: The hex string to split into RGB and Alpha.
 
 - Returns: A tuple of strings, where the first component is the RGB
            and the second component is the alpha
 */
public func extractColourComponents(from hex: String) -> String? {
    let range = NSRange(hex.startIndex..., in: hex)
    guard let matchingString = hexRegex.firstMatch(in: hex, options: [], range: range),
          let rgbRange = Range(matchingString.range(withName: "rgba"), in: hex) else {
        return nil
    }
    var resultHexString = hex[rgbRange]
    var resultHexStringCount = resultHexString.count
    assert((3 <= resultHexStringCount) && (resultHexStringCount <= 8), "Matched hex string musut be between 3 and 8 characters")
    if resultHexStringCount == 3 {
        resultHexString.append("f")
        resultHexStringCount += 1
    }
    if resultHexStringCount == 4 {
        var index = resultHexString.startIndex
        while index != resultHexString.endIndex {
            resultHexString.insert(resultHexString[index], at: index)
            index = resultHexString.index(after: index)
        }
        assert(resultHexString.count == 8, "Hex string expanded to full RGBA should be 8 characters")
        return String(resultHexString)
    }
    assert(resultHexStringCount == resultHexString.count)
    if resultHexStringCount == 6 {
        resultHexString.append("f")
        resultHexString.append("f")
    }
    
    return String(resultHexString)
}

public func hexStringToBytes<S : StringProtocol>(_ string: S) throws -> [UInt8] {
    let length = string.count
    // Must be even or this doesn't make sense
    if length & 1 != 0 {
        throw HexConversionError.badCount(count: length)
    }
    var bytes = [UInt8]()
    bytes.reserveCapacity(length/2)
    var curIndex = string.startIndex
    for _ in 0..<length/2 {
        let nextIndex = string.index(curIndex, offsetBy: 2)
        let indexRange = curIndex..<nextIndex
        guard let b = UInt8(string[indexRange], radix: 16) else {
            throw HexConversionError.badSubstring(string: String(string[indexRange]))
        }
        bytes.append(b)
        curIndex = nextIndex
    }
    return bytes
}

public enum HexConversionError: Error, LocalizedError, Equatable {
    case badCount(count: Int), badSubstring(string: String)
    
    public var errorDescription: String? {
        switch self {
        case .badCount(let count):
            return "Input string length incorrect. String was '\(count)' characters long, expected 6 or 8 characters."
        case .badSubstring(let badString):
            return "Unable to convert string segment '\(badString)' to an 8-bit integer."
        }
    }
    
    public var failureReason: String? {
        switch self {
        case .badCount(let count):
            return "Input string had length '\(count)', expected 6 or 8."
        case .badSubstring(let badString):
            return "Segment '\(badString)' could not be converted to an 8-bit integer."
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        default:
            return "Confirm this is a valid hex string."
        }
    }
}
