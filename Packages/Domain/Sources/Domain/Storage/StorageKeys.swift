// Domain/Storage/StorageKeys.swift
import Foundation

public enum StorageKeys: String, CaseIterable {
    // Auth
    case isLoggedIn  = "isLoggedIn"
    case currentUser = "currentUser"

    // Streak
    case streakCount    = "streakCount"
    case lastStreakDate = "lastStreakDate"
}
