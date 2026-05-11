// Domain/Storage/LocalStorageManager.swift
import Foundation

public struct LocalStorageManager {
    private let defaults: UserDefaults

    public static let shared = LocalStorageManager()

    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    // MARK: - Generic Helpers

    public func save<T: Encodable>(_ value: T, for key: StorageKeys) {
        let data = try? JSONEncoder().encode(value)
        defaults.set(data, forKey: key.rawValue)
        defaults.synchronize()
    }

    public func load<T: Decodable>(_ type: T.Type, for key: StorageKeys) -> T? {
        guard let data = defaults.data(forKey: key.rawValue) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }

    public func saveBool(_ value: Bool, for key: StorageKeys) {
        defaults.set(value, forKey: key.rawValue)
        defaults.synchronize()
    }

    public func loadBool(for key: StorageKeys) -> Bool {
        defaults.bool(forKey: key.rawValue)
    }

    public func remove(for key: StorageKeys) {
        defaults.removeObject(forKey: key.rawValue)
    }

    // MARK: - Typed Convenience

    public func saveUser(_ user: User) {
        save(user, for: .currentUser)
    }

    public func loadUser() -> User? {
        load(User.self, for: .currentUser)
    }

    public func saveLoginState(_ isLoggedIn: Bool) {
        saveBool(isLoggedIn, for: .isLoggedIn)
    }

    public func loadLoginState() -> Bool {
        loadBool(for: .isLoggedIn)
    }

    public func saveStreakCount(_ count: Int) {
        defaults.set(count, forKey: StorageKeys.streakCount.rawValue)
    }

    public func loadStreakCount() -> Int {
        defaults.integer(forKey: StorageKeys.streakCount.rawValue)
    }

    public func saveLastStreakDate(_ date: Date) {
        save(date, for: .lastStreakDate)
    }

    public func loadLastStreakDate() -> Date? {
        load(Date.self, for: .lastStreakDate)
    }

    public func clearAll() {
        StorageKeys.allCases.forEach { remove(for: $0) }
    }
}
