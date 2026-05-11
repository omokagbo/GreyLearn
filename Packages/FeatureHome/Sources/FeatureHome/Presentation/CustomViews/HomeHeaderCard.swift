// FeatureHome/Presentation/CustomViews/HomeHeaderCard.swift
import SwiftUI
import DesignSystem

public struct HomeHeaderCard: View {
    let initials: String
    let streak: String
    let onProfileTap: () -> Void
    let onStreakTap: () -> Void
    let onChatTap: () -> Void

    public init(initials: String, streak: String, onProfileTap: @escaping () -> Void, onStreakTap: @escaping () -> Void, onChatTap: @escaping () -> Void) {
        self.initials     = initials
        self.streak       = streak
        self.onProfileTap = onProfileTap
        self.onStreakTap  = onStreakTap
        self.onChatTap    = onChatTap
    }

    public var body: some View {
        HStack {
            AppText(initials, style: .headline)
                .padding(10)
                .background(Color.greyMidPurple)
                .clipShape(Circle())
                .onTapGesture { onProfileTap() }

            Spacer()

            AppText(streak, style: .headline)
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .clipShape(Capsule())
                .overlay { Capsule().stroke(Color.greyLightPurple, lineWidth: 1) }
                .onLongPressGesture { onStreakTap() }

            Spacer()

            Image("messaging")
                .resizable()
                .scaledToFit()
                .frame(width: 22.22)
                .padding(10)
                .background(Color.greyMidPurple)
                .clipShape(Circle())
                .onTapGesture { onChatTap() }
        }
    }
}
