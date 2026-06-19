//
//  GreyLearnApp.swift
//  GreyLearn
//
//  Created by Emmanuel Omokagbo on 5/7/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.
//

import SwiftUI

@main
struct GreyLearnApp: App {
    @State private var appCoordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            AppCoordinatorView()
                .environment(appCoordinator)
        }
    }
}
