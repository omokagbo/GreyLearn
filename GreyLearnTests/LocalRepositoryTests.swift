//
// LocalRepositoryTests.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/10/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.

import XCTest
@testable import GreyLearn

final class LocalRepositoryTests: XCTestCase {

    // Each test gets a fresh in-memory UserDefaults suite so real storage is never touched
    var suiteName: String!
    var defaults: UserDefaults!
    var storage: LocalStorageManager!
    var repo: LocalRepository!

    override func setUp() {
        super.setUp()
        suiteName = UUID().uuidString
        defaults  = UserDefaults(suiteName: suiteName)!
        storage   = LocalStorageManager(defaults: defaults)
        repo      = LocalRepository(storage: storage)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: suiteName)
        super.tearDown()
    }

    func testStreakCountDefaultsToZero() {
        XCTAssertEqual(repo.loadStreakCount(), 0)
    }

    func testSaveAndLoadStreakCount() {
        repo.saveStreakCount(7)
        XCTAssertEqual(repo.loadStreakCount(), 7)
    }

    func testOverwriteStreakCount() {
        repo.saveStreakCount(3)
        repo.saveStreakCount(10)
        XCTAssertEqual(repo.loadStreakCount(), 10)
    }

    func testLastStreakDateDefaultsToNil() {
        XCTAssertNil(repo.loadLastStreakDate())
    }

    func testSaveAndLoadLastStreakDate() {
        let date = Calendar.current.startOfDay(for: Date())
        repo.saveLastStreakDate(date)
        let loaded = repo.loadLastStreakDate()
        XCTAssertNotNil(loaded)
        // Compare as time intervals to avoid sub-millisecond rounding
        XCTAssertEqual(loaded!.timeIntervalSince1970, date.timeIntervalSince1970, accuracy: 1.0)
    }

    // MARK: - Clear Streak

    func testClearStreakResetsCountToZero() {
        repo.saveStreakCount(5)
        repo.clearStreak()
        XCTAssertEqual(repo.loadStreakCount(), 0)
    }

    func testClearStreakRemovesLastDate() {
        repo.saveLastStreakDate(Date())
        repo.clearStreak()
        XCTAssertNil(repo.loadLastStreakDate())
    }

    // MARK: - User

    func testSaveAndLoadUser() {
        let user = User(
            id: UUID(),
            firstName: "Emmanuel",
            lastName: "Omokagbo",
            email: "e@test.com",
            profileImageURL: nil,
            status: .active,
            createdAt: Date(),
            updatedAt: Date()
        )
        storage.saveUser(user)
        let loaded = storage.loadUser()
        XCTAssertNotNil(loaded)
        XCTAssertEqual(loaded?.firstName, user.firstName)
        XCTAssertEqual(loaded?.lastName,  user.lastName)
        XCTAssertEqual(loaded?.email,     user.email)
    }

    func testLoadUserReturnsNilWhenNotSet() {
        XCTAssertNil(storage.loadUser())
    }

    // MARK: - Login State

    func testLoginStateDefaultsToFalse() {
        XCTAssertFalse(storage.loadLoginState())
    }

    func testSaveAndLoadLoginState() {
        storage.saveLoginState(true)
        XCTAssertTrue(storage.loadLoginState())
        storage.saveLoginState(false)
        XCTAssertFalse(storage.loadLoginState())
    }
}
