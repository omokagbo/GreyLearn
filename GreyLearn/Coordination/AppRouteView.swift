//
// AppRouteView.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/7/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.
    
import SwiftUI

struct AppRouteView: View {
    @Environment(AppCoordinator.self) private var appCoordinator

    let route: AppRoute
//    let snapSendService: SnapSendServiceProtocol
//    let imageUploadService: ImageUploadServiceProtocol

    var body: some View {
        switch route {
        case .login:
            LoginView()
                .environment(appCoordinator.loginCoordinator)
            
        case .home:
            HomeView(user: User.user)
                .environment(appCoordinator.homeCoordinator)
                .environment(appCoordinator.profileCoordinator)
                .environment(appCoordinator.pathCoordinator)
                .environment(appCoordinator.chatCoordinator)
            
        case .profile:
            ProfileView()
                .environment(appCoordinator.profileCoordinator)

        case .path(let course):
            PathView()
                .environment(appCoordinator.pathCoordinator)
            
        case .chat:
            ChatView()
                .environment(appCoordinator.chatCoordinator)
            
//        case .todayLearning:
//            ContentView()
            
//        case .badgeDetails:
//            ContentView()
        }
    }
}
