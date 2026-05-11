// AppCoordination/AppCoordinator.swift
import SwiftUI
import Domain

/// Root coordinator that owns the shared navigation state.
/// Feature coordinators hold a reference to this object and delegate
/// push/pop/login/logout calls through it.
@Observable
public final class AppCoordinator {
    public var path = NavigationPath()
    public var isLoggedIn: Bool
    public var currentUser: User?

    @ObservationIgnored
    private let storage: LocalStorageManager

    public init(dependencies: AppDependencies = .live) {
        storage     = dependencies.storage
        isLoggedIn  = dependencies.storage.loadLoginState()
        currentUser = dependencies.storage.loadUser()
    }

    public func push(_ route: AppRoute) {
        path.append(route)
    }

    public func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    public func popToRoot() {
        path = NavigationPath()
    }

    public func login(user: User) {
        storage.saveUser(user)
        storage.saveLoginState(true)
        currentUser = user
        isLoggedIn  = true
    }

    public func logout() {
        storage.saveLoginState(false)
        storage.remove(for: .currentUser)
        storage.remove(for: .streakCount)
        storage.remove(for: .lastStreakDate)
        isLoggedIn  = false
        currentUser = nil
        path        = NavigationPath()
    }
}
