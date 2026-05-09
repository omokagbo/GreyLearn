//
// ProfileCoordinator.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/9/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.
	
import SwiftUI

@Observable
final class ProfileCoordinator: Coordinator {
    private let appCoordinator: AppCoordinator

    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }

    func push(_ route: ProfileRoute) {
        switch route {
        case .profileHome:
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
