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
    var isLoggedIn: Bool
    var currentUser: User?
    var isLaunching: Bool = true

    @ObservationIgnored
    private let storage: LocalStorageManager

    private(set) var homeCoordinator: HomeCoordinator!
    private(set) var profileCoordinator: ProfileCoordinator!
    private(set) var pathCoordinator: PathCoordinator!
    private(set) var loginCoordinator: LoginCoordinator!
    private(set) var chatCoordinator: ChatCoordinator!

    init(dependencies: AppDependencies = .live) {
        storage     = dependencies.storage
        isLoggedIn  = dependencies.storage.loadLoginState()
        currentUser = dependencies.storage.loadUser()

        homeCoordinator    = HomeCoordinator(appCoordinator: self)
        profileCoordinator = ProfileCoordinator(appCoordinator: self)
        pathCoordinator    = PathCoordinator(appCoordinator: self)
        loginCoordinator   = LoginCoordinator(appCoordinator: self)
        chatCoordinator    = ChatCoordinator(appCoordinator: self)
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
        storage.remove(for: .streakCount)
        storage.remove(for: .lastStreakDate)
        isLoggedIn  = false
        currentUser = nil
    }
}
