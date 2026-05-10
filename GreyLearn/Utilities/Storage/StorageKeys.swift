//
// StorageKeys.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/10/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.

import Foundation

enum StorageKeys: String, CaseIterable {
    // Auth
    case isLoggedIn    = "isLoggedIn"
    case currentUser   = "currentUser"

    // Streaks
    case streaks       = "streaks"
}
