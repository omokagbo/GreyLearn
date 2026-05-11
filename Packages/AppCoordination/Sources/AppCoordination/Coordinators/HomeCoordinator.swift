// AppCoordination/Coordinators/HomeCoordinator.swift
import Foundation

@Observable
public final class HomeCoordinator: Coordinator {
    private let appCoordinator: AppCoordinator

    public init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }

    public func push(_ route: HomeRoute) {
        switch route {
        case .profile:
            appCoordinator.push(.profile)
        case .chat:
            appCoordinator.push(.chat)
        case .path(let course):
            appCoordinator.push(.path(course: course))
        }
    }

    public func pop() {
        appCoordinator.pop()
    }

    public func popToRoot() {
        appCoordinator.popToRoot()
    }
}
