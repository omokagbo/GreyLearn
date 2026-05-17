//
// HomeRouteView.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/17/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.

import SwiftUI

struct HomeRouteView: View {
    @Environment(HomeCoordinator.self) private var homeCoordinator
    @Environment(AppCoordinator.self) private var appCoordinator

    let route: HomeRoute

    var body: some View {
        switch route {
        case .profile:
            if let user = appCoordinator.currentUser {
                ProfileView(user: user, onLogout: {
                    appCoordinator.logout()
                })
                .environment(appCoordinator.profileCoordinator)
            }

        case .path(let course):
            PathView(course: course)
                .environment(appCoordinator.pathCoordinator)

        case .chat:
            ChatView()
                .environment(appCoordinator.chatCoordinator)
        }
    }
}
