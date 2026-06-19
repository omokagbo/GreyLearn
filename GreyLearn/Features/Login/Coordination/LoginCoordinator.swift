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

    func login(with user: User) {
        appCoordinator.login(user: user)
    }

    func pop() {}
    
    func popToRoot() {}
}
