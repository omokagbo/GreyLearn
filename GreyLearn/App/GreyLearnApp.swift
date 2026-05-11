//
//  GreyLearnApp.swift
//  GreyLearn
//
//  Created by Emmanuel Omokagbo on 5/7/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.
//

// Main app entry point. Imports every feature package and wires together the
// root navigation stack, feature coordinators, and launch screen overlay.

import SwiftUI
import AppCoordination
import FeatureLaunch
import FeatureLogin
import FeatureHome

@main
struct GreyLearnApp: App {
    // Root coordinator — owns shared navigation path, login state, and user.
    @State private var appCoordinator: AppCoordinator

    // Feature coordinators are created here (composition root) so that only the
    // app target needs to know about all feature packages.
    @State private var loginCoordinator: LoginCoordinator
    @State private var homeCoordinator: HomeCoordinator

    @State private var isLaunching = true

    init() {
        let app = AppCoordinator()
        _appCoordinator   = State(wrappedValue: app)
        _loginCoordinator = State(wrappedValue: LoginCoordinator(appCoordinator: app))
        _homeCoordinator  = State(wrappedValue: HomeCoordinator(appCoordinator: app))
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                // NavigationStack lives at the app level so every feature pushed
                // onto AppCoordinator.path is rendered by AppRouteView.
                NavigationStack(path: $appCoordinator.path) {
                    Group {
                        if appCoordinator.isLoggedIn, let user = appCoordinator.currentUser {
                            HomeView(user: user)
                                .environment(homeCoordinator)
                                .environment(appCoordinator)
                        } else {
                            LoginView()
                                .environment(loginCoordinator)
                        }
                    }
                    // navigationDestination must live inside the NavigationStack content.
                    .navigationDestination(for: AppRoute.self) { route in
                        AppRouteView(route: route)
                            .environment(appCoordinator)
                    }
                }

                if isLaunching {
                    LaunchScreenView()
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        isLaunching = false
                    }
                }
            }
        }
    }
}
