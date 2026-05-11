// AppCoordination/Coordinators/PathCoordinator.swift
import Foundation

@Observable
public final class PathCoordinator: Coordinator {
    private let appCoordinator: AppCoordinator

    /// Currently presented sheet route. PathView observes this to show sheets.
    public var presentedRoute: PathSheetRoute? = nil

    public init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }

    public func push(_ route: PathRoute) {
        switch route {
        case .badgeDetails(let module):
            presentedRoute = .badgeDetails(module: module)
        }
    }

    public func pop() {
        appCoordinator.pop()
    }

    public func popToRoot() {
        appCoordinator.popToRoot()
    }
}
