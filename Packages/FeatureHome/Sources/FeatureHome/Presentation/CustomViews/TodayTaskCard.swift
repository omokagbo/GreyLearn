// FeatureHome/Presentation/CustomViews/TodayTaskCard.swift
import SwiftUI
import DesignSystem

public struct TodayTaskCard: View {
    let topicName: String
    let sectionName: String

    public init(topicName: String, sectionName: String) {
        self.topicName   = topicName
        self.sectionName = sectionName
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                AppText("For today", style: .title2)
                Spacer()
            }

            HStack {
                TaskProgressView()
                    .frame(width: 60, height: 60)
                    .padding(.trailing, 10)

                VStack(alignment: .leading, spacing: 10) {
                    AppText(topicName, style: .callout)
                    HStack {
                        Image(systemName: "calendar")
                        AppText(sectionName, style: .caption)
                    }
                }

                Spacer()
                Image(systemName: "chevron.right")
            }
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding()
        .shadow(radius: 0.5)
    }
}
