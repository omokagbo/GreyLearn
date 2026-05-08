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
        case .home:
            ContentView()
            // CheckoutCoordinator is also injected because ScannerView's
            // sub-destination (CheckoutView) needs it from the environment.
//            ScannerView()
//                .environment(appCoordinator.scannerCoordinator)
//                .environment(appCoordinator.checkoutCoordinator)

        case .profile:
            ContentView()
//            SnapSendView(snapSendService: snapSendService)
//                .environment(appCoordinator.snapSendCoordinator)

        case .fullPath:
            ContentView()
//            ImageUploadView(uploadService: imageUploadService)
//                .environment(appCoordinator.imageUploadCoordinator)
        }
    }
}
