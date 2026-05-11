// DesignSystem/Extensions/View+Extension.swift
import SwiftUI

public extension View {
    /// Replaces the navigation back button with a custom arrow and calls `onPop` on tap.
    func customBackButton(onPop: @escaping () -> Void) -> some View {
        modifier(CustomBackButtonModifier(onPop: onPop))
    }
}
