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

    func loadStreakCount() -> Int {
        storage.loadStreakCount()
    }

    func saveStreakCount(_ count: Int) {
        storage.saveStreakCount(count)
    }

    func loadLastStreakDate() -> Date? {
        storage.loadLastStreakDate()
    }

    func saveLastStreakDate(_ date: Date) {
        storage.saveLastStreakDate(date)
    }

    func clearStreak() {
        storage.saveStreakCount(0)
        storage.remove(for: .lastStreakDate)
    }
}
