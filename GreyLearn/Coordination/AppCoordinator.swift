//
// AppCoordinator.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/7/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.

import SwiftUI
	
@Observable
final class AppCoordinator {
    var path = NavigationPath()

//    private(set) var homeCoordinator: HomeCoordinator!
//    private(set) var scannerCoordinator: ScannerCoordinator!
//    private(set) var checkoutCoordinator: CheckoutCoordinator!
//    private(set) var snapSendCoordinator: SnapSendCoordinator!
//    private(set) var imageUploadCoordinator: ImageUploadCoordinator!
//
//    init() {
//        homeCoordinator        = HomeCoordinator(appCoordinator: self)
//        scannerCoordinator     = ScannerCoordinator(appCoordinator: self)
//        checkoutCoordinator    = CheckoutCoordinator(appCoordinator: self)
//        snapSendCoordinator    = SnapSendCoordinator(appCoordinator: self)
//        imageUploadCoordinator = ImageUploadCoordinator(appCoordinator: self)
//    }
//
//    func push(_ route: AppRoute) {
//        path.append(route)
//    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path = NavigationPath()
    }
}
