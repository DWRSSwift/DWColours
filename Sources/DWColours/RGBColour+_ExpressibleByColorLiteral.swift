//
//  File.swift
//  
//
//  Created by David Stephens on 21/10/2020.
//

import Foundation

extension RGBColour: _ExpressibleByColorLiteral {
    public init(_colorLiteralRed red: Float, green: Float, blue: Float, alpha: Float) {
        self.init(red: Double(red), green: Double(green), blue: Double(blue), alpha: Double(alpha))
    }
    
    
}
