// FeatureProfile/Presentation/ProfileView.swift
import SwiftUI
import AppCoordination
import Domain
import DesignSystem

public struct ProfileView: View {
    @Environment(ProfileCoordinator.self) private var coordinator
    public let user: User
    public let onLogout: () -> Void

    public init(user: User, onLogout: @escaping () -> Void) {
        self.user     = user
        self.onLogout = onLogout
    }

    public var body: some View {
        VStack(spacing: 32) {
            Text(user.initials)
                .font(.system(size: 40, weight: .semibold))
                .foregroundStyle(Color.greyPurple)
                .frame(width: 100, height: 100)
                .background(Color.greyMidPurple)
                .clipShape(Circle())
                .padding(.top, 40)

            VStack(spacing: 0) {
                profileRow(label: "First name", value: user.firstName)
                Divider().padding(.horizontal)
                profileRow(label: "Last name",  value: user.lastName)
                Divider().padding(.horizontal)
                profileRow(label: "Email",       value: user.email)
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
            .padding(.horizontal)

            Spacer()

            PrimaryButton(title: "Log out", action: onLogout)
                .padding(.horizontal)
                .padding(.bottom, 32)
        }
        .background(Color.greyLightGray.ignoresSafeArea())
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func profileRow(label: String, value: String) -> some View {
        HStack {
            Text(label).foregroundStyle(Color.secondary).font(.subheadline)
            Spacer()
            Text(value).foregroundStyle(Color.primary).font(.subheadline).fontWeight(.medium)
        }
        .padding()
    }
}
