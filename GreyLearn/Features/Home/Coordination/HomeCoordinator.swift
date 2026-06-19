//
// HomeCoordinator.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/9/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.
    
import SwiftUI

@Observable
final class HomeCoordinator: Coordinator {
    // Each feature owns its own path — scoped navigationDestination per feature.
    var path: [HomeRoute] = []

    init(appCoordinator: AppCoordinator) {}

    func push(_ route: HomeRoute) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path = []
    }
}
