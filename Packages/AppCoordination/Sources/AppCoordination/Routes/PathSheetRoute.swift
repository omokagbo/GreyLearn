// AppCoordination/Routes/PathSheetRoute.swift
import Foundation
import Domain

/// Sheet destinations within the Path feature.
/// Note: `makeView()` is intentionally absent. The consuming view (PathView)
/// switches on this enum and creates the appropriate SwiftUI view directly,
/// keeping DesignSystem/AppCoordination free from any FeaturePath dependency.
public enum PathSheetRoute: Identifiable {
    case badgeDetails(module: Module)

    public var id: String {
        switch self {
        case .badgeDetails(let module): return "badgeDetails-\(module.id)"
        }
    }

    public var sheetHeight: CGFloat {
        switch self {
        case .badgeDetails: return 0.9
        }
    }
}
