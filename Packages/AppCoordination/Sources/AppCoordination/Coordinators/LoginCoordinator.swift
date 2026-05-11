// AppCoordination/Coordinators/LoginCoordinator.swift
import Foundation
import Domain

@Observable
public final class LoginCoordinator: Coordinator {
    private let appCoordinator: AppCoordinator

    public init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }

    public func login(with user: User) {
        appCoordinator.login(user: user)
    }

    public func pop() {
        appCoordinator.pop()
    }

    public func popToRoot() {
        appCoordinator.popToRoot()
    }
}
