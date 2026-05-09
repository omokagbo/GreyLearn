//
// HomeCoordinator.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/9/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.
	
import SwiftUI

@Observable
final class HomeCoordinator: Coordinator {
    private let appCoordinator: AppCoordinator

    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }

    func push(_ route: HomeRoute) {
        switch route {
        case .profile:
            appCoordinator.push(AppRoute.profile)
        case .chat:
            appCoordinator.push(AppRoute.chat)
        case .fullPath:
            appCoordinator.push(AppRoute.path)
//        case .todayLearning:
//            appCoordinator.push(AppRoute.todayLearning)
        }
    }

    func pop() {
        appCoordinator.pop()
    }
    
    func popToRoot() {
        appCoordinator.popToRoot()
    }
    
}
