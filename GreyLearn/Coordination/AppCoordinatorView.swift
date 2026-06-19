//
// AppCoordinatorView.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/17/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.

import SwiftUI

struct AppCoordinatorView: View {
    @Environment(AppCoordinator.self) private var appCoordinator

    var body: some View {
        ZStack {
            if appCoordinator.isLoggedIn, let user = appCoordinator.currentUser {
                HomeView(user: user)
                    .environment(appCoordinator.homeCoordinator)
                    .environment(appCoordinator)
            } else {
                LoginView()
                    .environment(appCoordinator.loginCoordinator)
            }

            if appCoordinator.isLaunching {
                LaunchScreenView()
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeOut(duration: 0.5)) {
                    appCoordinator.isLaunching = false
                }
            }
        }
    }
}
