//
//  ColourSerialisation.swift
//  WatchTime
//
//  Created by David Stephens on 30/09/2020.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif
import SwiftUI

extension DWColours {
    #if canImport(UIKit)
    public typealias ColourType = UIColor
    #elseif canImport(AppKit)
    public typealias ColourType = NSColor
    #endif
    
    @available(iOS 14.0, OSX 11, tvOS 14, watchOS 7.0, *)
    public static func extractRGB(from colour: Color) -> RGBColour {
        return extractRGB(from: ColourType(colour))
    }
    
    public static func extractRGB(from colourType: ColourType) -> RGBColour {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        colourType.getRed(&r, green: &g, blue: &b, alpha: &a)
        return RGBColour(red: Double(r), green: Double(g), blue: Double(b), alpha: Double(a))
    }
}
