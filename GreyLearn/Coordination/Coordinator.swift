//
// Coordinator.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/7/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.
	
import SwiftUI

@MainActor
protocol Coordinator: AnyObject, Observable {
    associatedtype RouteType: Hashable
    func push(_ route: RouteType)
    func pop()
    func popToRoot()
}
