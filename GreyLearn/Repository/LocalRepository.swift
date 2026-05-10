//
// LocalRepository.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/10/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.

import Foundation

struct LocalRepository {
    private let storage: LocalStorageManager

    init(storage: LocalStorageManager = .shared) {
        self.storage = storage
    }

    func retrieveStreaks() -> [Streak] {
        storage.loadStreaks()
    }

    func saveStreaks(_ streaks: [Streak]) {
        storage.saveStreaks(streaks)
    }
}
