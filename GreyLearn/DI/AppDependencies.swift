//
// AppDependencies.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/10/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.

import Foundation

struct AppDependencies {
    let storage: LocalStorageManager

    static let live = AppDependencies(
        storage: .shared
    )
}
