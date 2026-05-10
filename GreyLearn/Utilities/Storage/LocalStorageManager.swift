//
// LocalStorageManager.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/10/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.

import Foundation

struct LocalStorageManager {
    private let defaults: UserDefaults

    static let shared = LocalStorageManager()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    // MARK: - Generic Helpers

    func save<T: Encodable>(_ value: T, for key: StorageKeys) {
        let data = try? JSONEncoder().encode(value)
        defaults.set(data, forKey: key.rawValue)
    }

    func load<T: Decodable>(_ type: T.Type, for key: StorageKeys) -> T? {
        guard let data = defaults.data(forKey: key.rawValue) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }

    func saveBool(_ value: Bool, for key: StorageKeys) {
        defaults.set(value, forKey: key.rawValue)
    }

    func loadBool(for key: StorageKeys) -> Bool {
        defaults.bool(forKey: key.rawValue)
    }

    func remove(for key: StorageKeys) {
        defaults.removeObject(forKey: key.rawValue)
    }

    // MARK: - Typed Convenience

    func saveUser(_ user: User) {
        save(user, for: .currentUser)
    }

    func loadUser() -> User? {
        load(User.self, for: .currentUser)
    }

    func saveLoginState(_ isLoggedIn: Bool) {
        saveBool(isLoggedIn, for: .isLoggedIn)
    }

    func loadLoginState() -> Bool {
        loadBool(for: .isLoggedIn)
    }

    func saveStreaks(_ streaks: [Streak]) {
        save(streaks, for: .streaks)
    }

    func loadStreaks() -> [Streak] {
        load([Streak].self, for: .streaks) ?? []
    }

    func clearAll() {
        StorageKeys.allCases.forEach { remove(for: $0) }
    }
}
