// AppCoordination/Coordinators/ProfileCoordinator.swift
import Foundation

@Observable
public final class ProfileCoordinator: Coordinator {
    private let appCoordinator: AppCoordinator

    public init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }

    public func pop() {
        appCoordinator.pop()
    }

    public func popToRoot() {
        appCoordinator.popToRoot()
    }
}
