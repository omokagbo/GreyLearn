//
//  AppCoordinator.swift
//  GreyLearn
//
//  Created by Emmanuel Omokagbo on 5/7/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.
//

import SwiftUI

@Observable
final class AppCoordinator {
    var path = NavigationPath()
    var isLoggedIn: Bool
    var currentUser: User?

    @ObservationIgnored
    private let storage = LocalStorageManager.shared

    private(set) var homeCoordinator: HomeCoordinator!
    private(set) var profileCoordinator: ProfileCoordinator!
    private(set) var pathCoordinator: PathCoordinator!
    private(set) var loginCoordinator: LoginCoordinator!
    private(set) var chatCoordinator: ChatCoordinator!

    init() {
        isLoggedIn  = LocalStorageManager.shared.loadLoginState()
        currentUser = LocalStorageManager.shared.loadUser()

        homeCoordinator    = HomeCoordinator(appCoordinator: self)
        profileCoordinator = ProfileCoordinator(appCoordinator: self)
        pathCoordinator    = PathCoordinator(appCoordinator: self)
        loginCoordinator   = LoginCoordinator(appCoordinator: self)
        chatCoordinator    = ChatCoordinator(appCoordinator: self)
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

    func login(user: User) {
        storage.saveUser(user)
        storage.saveLoginState(true)
        currentUser = user
        isLoggedIn  = true
    }

    func logout() {
        storage.saveLoginState(false)
        storage.remove(for: .currentUser)
        storage.remove(for: .streaks)
        isLoggedIn  = false
        currentUser = nil
        path        = NavigationPath()
    }
}
