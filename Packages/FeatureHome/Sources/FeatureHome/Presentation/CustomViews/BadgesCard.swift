// FeatureHome/Presentation/CustomViews/BadgesCard.swift
import SwiftUI
import DesignSystem

public struct BadgesCard: View {
    let badges: [String]

    public init(badges: [String]) { self.badges = badges }

    public var body: some View {
        VStack(alignment: .leading) {
            AppText("Badges", style: .title3)

            HStack(spacing: 20) {
                ForEach(badges, id: \.self) { badge in
                    VStack {
                        Image(badge)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 80)
                            .padding(.bottom, 10)
                        AppText("Genius", style: .caption)
                        AppText("3/3 perfect scores", style: .caption2)
                    }
                }
            }
        }
        .padding()
    }
}
