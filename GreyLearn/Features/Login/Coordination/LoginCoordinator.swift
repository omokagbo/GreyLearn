//
// LoginCoordinator.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/9/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.
	
import Foundation

@Observable
final class LoginCoordinator: Coordinator {
    private let appCoordinator: AppCoordinator

    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }

    func push(_ route: LoginRoute) {
        switch route {
        case .login:
            appCoordinator.push(AppRoute.profile)
        }
    }

    func pop() {
        appCoordinator.pop()
    }
    
    func popToRoot() {
        appCoordinator.popToRoot()
    }
}

