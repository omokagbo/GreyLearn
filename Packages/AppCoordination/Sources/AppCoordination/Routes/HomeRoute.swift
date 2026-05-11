// AppCoordination/Routes/HomeRoute.swift
import Foundation
import Domain

/// Navigation destinations within the Home feature.
public enum HomeRoute: Hashable {
    case profile
    case chat
    case path(course: Course)
}
