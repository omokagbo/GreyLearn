//
// HomeRoute.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/9/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.

import Foundation

enum HomeRoute: Hashable {
    case profile
    case chat
    case path(course: Course)
    //case todayLearning
}

