//
// AppCoordinator.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/7/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.

import SwiftUI
	
@Observable
final class AppCoordinator {
    var path = NavigationPath()

    private(set) var homeCoordinator: HomeCoordinator!
    private(set) var profileCoordinator: ProfileCoordinator!
    private(set) var pathCoordinator: PathCoordinator!
    private(set) var loginCoordinator: LoginCoordinator!
    private(set) var chatCoordinator: ChatCoordinator!

    init() {
        homeCoordinator        = HomeCoordinator(appCoordinator: self)
        profileCoordinator     = ProfileCoordinator(appCoordinator: self)
        pathCoordinator        = PathCoordinator(appCoordinator: self)
        loginCoordinator       = LoginCoordinator(appCoordinator: self)
        chatCoordinator        = ChatCoordinator(appCoordinator: self)
    }

    func push(_ route: AppRoute) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path = NavigationPath()
    }
}
