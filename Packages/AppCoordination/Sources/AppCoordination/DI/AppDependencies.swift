// AppCoordination/DI/AppDependencies.swift
import Foundation
import Domain

public struct AppDependencies {
    public let storage: LocalStorageManager

    public init(storage: LocalStorageManager) {
        self.storage = storage
    }

    public static let live = AppDependencies(storage: .shared)
}
