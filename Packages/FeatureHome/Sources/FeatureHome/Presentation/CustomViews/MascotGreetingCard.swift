// FeatureHome/Presentation/CustomViews/MascotGreetingCard.swift
import SwiftUI
import DesignSystem
import Core

public struct MascotGreetingCard: View {
    let firstName: String

    public init(firstName: String) { self.firstName = firstName }

    public var body: some View {
        VStack(spacing: 10) {
            Image("Mascot")
                .resizable()
                .scaledToFit()
                .frame(height: 200)

            AppText(Date().greeting(withName: firstName), style: .title)
            AppText("You're closer than you think 💪🏾", style: .subheadline)
        }
    }
}
