// DesignSystem/Colors/Color+Extensions.swift
import SwiftUI

// Strongly-typed wrappers around the named colours defined in the main app's
// Assets.xcassets/Colors catalogue. At runtime SwiftUI resolves these names
// from Bundle.main, so the asset files stay in the Xcode app target as-is.
public extension Color {
    static let greyPurple      = Color("grey-purple")
    static let greyLightGray   = Color("grey-light-gray")
    static let greyMidPurple   = Color("grey-mid-purple")
    static let greyLightPurple = Color("grey-light-purple")
    static let greyBlue        = Color("grey-blue")
    static let greyLightBlue   = Color("grey-light-blue")
}
