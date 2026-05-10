//
//  ChatCoordinator.swift
//  GreyLearn
//
//  Created by Emmanuel Omokagbo on 5/9/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.
//

import SwiftUI

@Observable
final class ChatCoordinator: Coordinator {
    private let appCoordinator: AppCoordinator

    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }

    func pop() {
        appCoordinator.pop()
    }

    func popToRoot() {
        appCoordinator.popToRoot()
    }
}
