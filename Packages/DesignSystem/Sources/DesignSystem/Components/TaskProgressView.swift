// DesignSystem/Components/TaskProgressView.swift
import SwiftUI

/// A circular progress indicator shown on the today-task card.
public struct TaskProgressView: View {
    public init() {}

    public var body: some View {
        ZStack {
            Image("grey-badge")
                .resizable()
                .scaledToFit()
                .padding(10)

            Circle()
                .stroke(Color.greyLightGray, lineWidth: 4)
        }
    }
}
