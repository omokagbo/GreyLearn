//
// LoginView.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/9/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.

import SwiftUI

struct LoginView: View {
    @Environment(LoginCoordinator.self) private var coordinator
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                // Header
                VStack(spacing: 12) {
                    Image("Mascot")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 120)

                    AppText("Welcome to GreyLearn", style: .title)
                        .multilineTextAlignment(.center)

                    AppText("Enter your details to get started", style: .subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.secondary)
                }
                .padding(.top, 60)
                .padding(.bottom, 40)
                .padding(.horizontal)

                // Fields
                VStack(spacing: 20) {
                    inputField(
                        title: "First Name",
                        placeholder: "e.g. Emmanuel",
                        text: $viewModel.firstName,
                        error: viewModel.firstNameError
                    )

                    inputField(
                        title: "Last Name",
                        placeholder: "e.g. Omokagbo",
                        text: $viewModel.lastName,
                        error: viewModel.lastNameError
                    )

                    inputField(
                        title: "Email",
                        placeholder: "e.g. you@example.com",
                        text: $viewModel.email,
                        error: viewModel.emailError,
                        keyboardType: .emailAddress
                    )
                }
                .padding(.horizontal)

                // Sign in button
                Button {
                    viewModel.signIn { user in
                        coordinator.login(with: user)
                    }
                } label: {
                    ZStack {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Sign In")
                        }
                    }
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .background(Color.greyPurple)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .disabled(viewModel.isLoading)
                .padding(.horizontal)
                .padding(.top, 36)
                .padding(.bottom, 40)
            }
        }
        .background(Color.greyLightGray.ignoresSafeArea())
        .navigationBarHidden(true)
    }

    private func inputField(
        title: String,
        placeholder: String,
        text: Binding<String>,
        error: String?,
        keyboardType: UIKeyboardType = .default
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            AppText(title, style: .callout)
                .foregroundStyle(Color.primary)

            TextField(placeholder, text: text)
                .keyboardType(keyboardType)
                .autocorrectionDisabled()
                .textInputAutocapitalization(keyboardType == .emailAddress ? .never : .words)
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(error != nil ? Color.red.opacity(0.7) : Color.greyLightPurple, lineWidth: 1)
                }

            if let error {
                AppText(error, style: .caption)
                    .foregroundStyle(Color.red)
            }
        }
    }
}

#Preview {
    NavigationStack {
        LoginView()
            .environment(LoginCoordinator(appCoordinator: AppCoordinator()))
    }
}
