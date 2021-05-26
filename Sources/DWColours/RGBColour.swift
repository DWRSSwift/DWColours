//
//  File.swift
//  
//
//  Created by David Stephens on 04/10/2020.
//

import Foundation
import SwiftUI

public struct RGBColour: Equatable {
    public let red: Double
    public let green: Double
    public let blue: Double
    public let alpha: Double
    
    public init(red: Double, green: Double, blue: Double, alpha: Double = 1.0) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    public var cgColor: CGColor? {
        let colourSpace = CGColorSpace(name: CGColorSpace.extendedSRGB)!
        let colourComponenets = [
            CGFloat(red),
            CGFloat(green),
            CGFloat(blue),
            CGFloat(alpha)
        ]
        return CGColor(colorSpace: colourSpace, components: colourComponenets)
    }
    
    #if os(macOS)
    var nsColor: NSColor {
        return NSColor(ciColor: CIColor(cgColor: self.cgColor!))
    }
    #endif
    
    
    @available(iOS 14.0, OSX 11, tvOS 10.14, watchOS 7, *)
    public var color: Color? {
        guard let cgColor = self.cgColor else {
            return nil
        }
        return Color(cgColor)
    }
    
    public func getBrightness() -> Double {
        #if canImport(UIKit)
        typealias ColourType = UIColor
        #elseif canImport(AppKit)
        typealias ColourType = NSColor
        #endif
        let c: ColourType
        if #available(watchOS 7, *) {
            c = ColourType(self.color!)
        } else {
            c = ColourType(cgColor: self.cgColor!)
        }
        var brightness: CGFloat = CGFloat()
        c.getHue(nil, saturation: nil, brightness: &brightness, alpha: nil)
        return Double(brightness)
    }
}

extension RGBColour {
    public init?(fromHex hex: String) throws {
        guard let colourString = extractColourComponents(from: hex) else {
            return nil
        }
        let hexBytes = try hexStringToBytes(colourString)
        let r = Double(hexBytes[0]) / 255
        let g = Double(hexBytes[1]) / 255
        let b = Double(hexBytes[2]) / 255
        let a = Double(hexBytes[3]) / 255
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}


@available(iOS 14.0, OSX 11, watchOS 7.0, *)
public extension RGBColour {
    static let black = DWColours.extractRGB(from: Color.black)
    static let blue = DWColours.extractRGB(from: Color.blue)
    static let green = DWColours.extractRGB(from: Color.green)
    static let gray = DWColours.extractRGB(from: Color.gray)
    static let orange = DWColours.extractRGB(from: Color.orange)
    static let magenta = DWColours.extractRGB(from: DWColours.Shades.magenta)
    static let pink = DWColours.extractRGB(from: Color.pink)
    static let purple = DWColours.extractRGB(from: Color.purple)
    static let red = DWColours.extractRGB(from: Color.red)
    static let white = DWColours.extractRGB(from: Color.white)
    static let yellow = DWColours.extractRGB(from: Color.yellow)
}
