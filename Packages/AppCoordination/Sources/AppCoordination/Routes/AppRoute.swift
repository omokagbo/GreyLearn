// AppCoordination/Routes/AppRoute.swift
import Foundation
import Domain

/// Top-level navigation destinations managed by AppCoordinator.
public enum AppRoute: Hashable {
    case path(course: Course)
    case profile
    case chat
}
