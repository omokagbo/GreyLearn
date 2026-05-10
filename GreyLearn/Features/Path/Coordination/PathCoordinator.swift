//
// PathCoordinator.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/9/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.
    
import SwiftUI

@Observable
final class PathCoordinator: Coordinator {
    private let appCoordinator: AppCoordinator
    var presentedRoute: PathSheetRoute? = nil

    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }

    func push(_ route: PathRoute) {
        switch route {
        case .path:
            appCoordinator.push(AppRoute.path(course: Course.mockCourse))
        case .badgeDetails(let module):
            presentedRoute = .badgeDetails(module: module)
        }
    }

    func pop() {
        appCoordinator.pop()
    }
    
    func popToRoot() {
        appCoordinator.popToRoot()
    }
}
