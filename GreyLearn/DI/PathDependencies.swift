//
// PathDependencies.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/10/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.

import Foundation

struct PathDependencies {
    let localRepository: LocalRepository

    static let live = PathDependencies(
        localRepository: LocalRepository()
    )
}
