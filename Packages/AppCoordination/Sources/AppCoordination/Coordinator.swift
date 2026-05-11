// AppCoordination/Coordinator.swift
import SwiftUI

/// Base protocol all feature coordinators conform to.
@MainActor
public protocol Coordinator: AnyObject, Observable {
    func pop()
    func popToRoot()
}
