//
// PathCoordinator.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/9/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.
	
import SwiftUI

@Observable
final class PathCoordinator: Coordinator {
    private let appCoordinator: AppCoordinator

    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }

    func push(_ route: PathRoute) {
        switch route {
        case .path:
            appCoordinator.push(AppRoute.profile)
//        case .badgeDetails:
//            appCoordinator.
        }
    }

    func pop() {
        appCoordinator.pop()
    }
    
    func popToRoot() {
        appCoordinator.popToRoot()
    }
}
