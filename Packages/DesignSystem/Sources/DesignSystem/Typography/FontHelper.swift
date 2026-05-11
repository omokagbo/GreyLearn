// DesignSystem/Typography/FontHelper.swift
import SwiftUI

public struct FontHelper {
    public static func aeonik(_ font: AeonikFont, size: CGFloat) -> Font {
        .custom(font.rawValue, size: size)
    }
}
