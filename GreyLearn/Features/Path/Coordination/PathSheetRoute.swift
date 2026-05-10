//
// PathSheetRoute.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/10/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.

import SwiftUI

enum PathSheetRoute: Identifiable {
    case badgeDetails(module: Module)

    var id: String {
        switch self {
        case .badgeDetails(let module):
            "badgeDetails-\(module.id)"
        }
    }

    var sheetHeight: CGFloat {
        switch self {
        case .badgeDetails:
            0.9
        }
    }

    @ViewBuilder
    func makeView() -> some View {
        switch self {
        case .badgeDetails(let module):
            BadgeEarnedView(module: module)
        }
    }
}
