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

    // Persisted login state
    @ObservationIgnored
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false

    // Persisted user (JSON encoded)
    @ObservationIgnored
    @AppStorage("currentUser") private var currentUserData: String = ""

    var currentUser: User? {
        get {
            guard let data = currentUserData.data(using: .utf8) else { return nil }
            return try? JSONDecoder().decode(User.self, from: data)
        }
        set {
            if let user = newValue,
               let data = try? JSONEncoder().encode(user),
               let json = String(data: data, encoding: .utf8) {
                currentUserData = json
            } else {
                currentUserData = ""
            }
        }
    }

    private(set) var homeCoordinator: HomeCoordinator!
    private(set) var profileCoordinator: ProfileCoordinator!
    private(set) var pathCoordinator: PathCoordinator!
    private(set) var loginCoordinator: LoginCoordinator!
    private(set) var chatCoordinator: ChatCoordinator!

    init() {
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
        currentUser = user
        isLoggedIn = true
    }

    func logout() {
        isLoggedIn = false
        currentUser = nil
        path = NavigationPath()
    }
}
