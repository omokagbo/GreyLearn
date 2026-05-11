// Domain/Repository/LocalRepository.swift
import Foundation

public struct LocalRepository {
    private let storage: LocalStorageManager

    public init(storage: LocalStorageManager = .shared) {
        self.storage = storage
    }

    public func loadStreakCount() -> Int {
        storage.loadStreakCount()
    }

    public func saveStreakCount(_ count: Int) {
        storage.saveStreakCount(count)
    }

    public func loadLastStreakDate() -> Date? {
        storage.loadLastStreakDate()
    }

    public func saveLastStreakDate(_ date: Date) {
        storage.saveLastStreakDate(date)
    }

    public func clearStreak() {
        storage.saveStreakCount(0)
        storage.remove(for: .lastStreakDate)
    }
}
