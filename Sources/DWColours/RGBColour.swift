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
