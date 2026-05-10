//
//  AppRoute.swift
//  GreyLearn
//
//  Created by Emmanuel Omokagbo on 5/7/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.
//

import Foundation

enum AppRoute: Hashable {
    case path(course: Course)
    case profile
    case chat
}
