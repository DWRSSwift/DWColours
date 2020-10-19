import SwiftUI

public enum DWColours {
    @available(iOS 13.0, OSX 10.15, watchOS 6.0, *)
    public enum Shades {
        public static var magenta: Color = {
            #if !os(macOS)
            return Color(UIColor.magenta)
            #else
            return Color(NSColor.magenta)
            #endif
        }()
    }
}
