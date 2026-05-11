// DesignSystem/Components/PrimaryButton.swift
import SwiftUI

/// A full-width primary action button using the GreyLearn brand colour.
public struct PrimaryButton: View {
    let title: String
    let action: () -> Void

    public init(title: String, action: @escaping () -> Void) {
        self.title  = title
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(title)
                .padding(.vertical, 15)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white, .gray)
                .background(Color.greyPurple)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .contentShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}
