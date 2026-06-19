//
// ProfileView.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/9/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.

import SwiftUI

struct ProfileView: View {
    @Environment(ProfileCoordinator.self) private var coordinator
    let user: User
    let onLogout: () -> Void

    var body: some View {
        VStack(spacing: 32) {

            // Initials avatar
            Text(user.initials)
                .font(.system(size: 40, weight: .semibold))
                .foregroundStyle(Color.greyPurple)
                .frame(width: 100, height: 100)
                .background(Color.greyMidPurple)
                .clipShape(Circle())
                .padding(.top, 40)

            // Info card
            VStack(spacing: 0) {
                profileRow(label: "First name", value: user.firstName)
                Divider().padding(.horizontal)
                profileRow(label: "Last name", value: user.lastName)
                Divider().padding(.horizontal)
                profileRow(label: "Email", value: user.email)
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
            .padding(.horizontal)

            Spacer()

            // Logout button
            PrimaryButton(title: "Log out") {
                onLogout()
            }
            .padding(.horizontal)
            .padding(.bottom, 32)
        }
        .background(Color.greyLightGray.ignoresSafeArea())
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .customBackButton()
    }

    private func profileRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(Color.secondary)
                .font(.subheadline)
            Spacer()
            Text(value)
                .foregroundStyle(Color.primary)
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        ProfileView(user: .user, onLogout: {})
            .environment(ProfileCoordinator(appCoordinator: AppCoordinator()))
    }
}
