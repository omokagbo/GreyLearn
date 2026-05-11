// DesignSystem/Modifiers/CustomBackButtonModifier.swift
import SwiftUI

/// Hides the default back button and shows a custom arrow.
/// The `onPop` closure is called when the button is tapped, allowing
/// feature packages to trigger navigation without importing AppCoordination.
public struct CustomBackButtonModifier: ViewModifier {
    let onPop: () -> Void

    public init(onPop: @escaping () -> Void) {
        self.onPop = onPop
    }

    public func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: onPop) {
                        Image(systemName: "arrow.backward")
                            .font(.headline)
                    }
                }
            }
    }
}
