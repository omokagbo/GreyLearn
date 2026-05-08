//
// GreyLearnApp.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/7/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.
    

import SwiftUI

@main
struct GreyLearnApp: App {
    @State private var isLaunching = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()

                if isLaunching {
                    LaunchScreenView()
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        isLaunching = false
                    }
                }
            }
        }
    }
}
