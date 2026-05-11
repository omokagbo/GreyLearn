//
//  AppRouteView.swift
//  GreyLearn
//
//  Created by Emmanuel Omokagbo on 5/7/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.
//

// AppRouteView.swift — Composition root for route → view mapping.
// This file intentionally lives in the main app target because it is the only
// place that imports ALL feature packages simultaneously.

import SwiftUI
import AppCoordination
import Domain
import FeatureChat
import FeaturePath
import FeatureProfile

struct AppRouteView: View {
    @Environment(AppCoordinator.self) private var appCoordinator
    let route: AppRoute

    var body: some View {
        switch route {
        case .profile:
            if let user = appCoordinator.currentUser {
                ProfileView(user: user, onLogout: { appCoordinator.logout() })
                    .environment(ProfileCoordinator(appCoordinator: appCoordinator))
            }

        case .path(let course):
            PathView(course: course)
                .environment(PathCoordinator(appCoordinator: appCoordinator))

        case .chat:
            ChatView()
                .environment(ChatCoordinator(appCoordinator: appCoordinator))
        }
    }
}
