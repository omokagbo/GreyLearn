//
// HomeViewModelTests.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/10/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.

import XCTest
@testable import GreyLearn

@MainActor
final class HomeViewModelTests: XCTestCase {

    /// Stub repository that returns a given course instantly
    private struct StubRepository: CourseRepository {
        let course: Course
        func fetchActiveCourse() async throws -> Course { course }
    }

    /// Stub repository that always throws
    private struct FailingRepository: CourseRepository {
        func fetchActiveCourse() async throws -> Course {
            throw URLError(.notConnectedToInternet)
        }
    }

    private var suiteName: String!
    private var defaults: UserDefaults!
    private var storage: LocalStorageManager!
    private var localRepo: LocalRepository!

    override func setUp() {
        super.setUp()
        suiteName = UUID().uuidString
        defaults  = UserDefaults(suiteName: suiteName)!
        storage   = LocalStorageManager(defaults: defaults)
        localRepo = LocalRepository(storage: storage)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: suiteName)
        super.tearDown()
    }

    private func makeViewModel(repository: CourseRepository? = nil) -> HomeViewModel {
        HomeViewModel(dependencies: HomeDependencies(
            courseRepository: repository ?? StubRepository(course: Course.mockCourse),
            localRepository: localRepo
        ))
    }

    func testLoadsCourseFromRepository() async throws {
        let testCourse = Course(
            id: "test-id",
            name: "Test Course",
            description: "A test course.",
            modules: Course.mockCourse.modules,
            isActive: true,
            isDeleted: false,
            createdAt: Date(),
            updatedAt: Date()
        )

        let vm = makeViewModel(repository: StubRepository(course: testCourse))
        vm.getCourse()

        let loaded = try await waitForCourse(in: vm)
        XCTAssertTrue(loaded, "activeCourse should be set within timeout")
        XCTAssertEqual(vm.activeCourse?.id, testCourse.id)
        XCTAssertEqual(vm.activeCourse?.name, testCourse.name)
    }

    func testActiveCourseRemainsNilOnRepositoryFailure() async throws {
        let vm = makeViewModel(repository: FailingRepository())
        vm.getCourse()

        try await Task.sleep(nanoseconds: 300_000_000)
        XCTAssertNil(vm.activeCourse)
    }

    func testStreakDisplaysZeroOnFirstLaunch() {
        let vm = makeViewModel()
        vm.getStreak()
        XCTAssertEqual(vm.streak, "🔥 0 days")
    }

    func testStreakDisplayRestoredFromStorageOnInit() {
        localRepo.saveStreakCount(7)
        let vm = makeViewModel()
        XCTAssertEqual(vm.streak, "🔥 7 days")
    }

    func testStreakSingularDay() {
        localRepo.saveStreakCount(1)
        let vm = makeViewModel()
        XCTAssertEqual(vm.streak, "🔥 1 day")
    }

    func testGetStreakSameDayDoesNotResetCount() {
        localRepo.saveStreakCount(5)
        localRepo.saveLastStreakDate(Calendar.current.startOfDay(for: Date()))
        let vm = makeViewModel()
        vm.getStreak()
        XCTAssertEqual(vm.streak, "🔥 5 days")
    }

    func testGetStreakYesterdayPreservesCount() {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        localRepo.saveStreakCount(4)
        localRepo.saveLastStreakDate(yesterday)
        let vm = makeViewModel()
        vm.getStreak()
        XCTAssertEqual(vm.streak, "🔥 4 days")
    }

    func testGetStreakMissedDayResetsToZero() {
        let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: Date())!
        localRepo.saveStreakCount(10)
        localRepo.saveLastStreakDate(twoDaysAgo)
        let vm = makeViewModel()
        vm.getStreak()
        XCTAssertEqual(vm.streak, "🔥 0 days")
    }

    func testRecordActivityIncrementsStreak() {
        localRepo.saveStreakCount(3)
        let vm = makeViewModel()
        vm.recordActivity()
        XCTAssertEqual(vm.streak, "🔥 4 days")
        XCTAssertEqual(localRepo.loadStreakCount(), 4)
    }

    func testRecordActivityPersistsLastDate() {
        let vm = makeViewModel()
        vm.recordActivity()
        let saved = localRepo.loadLastStreakDate()
        XCTAssertNotNil(saved)
        XCTAssertTrue(Calendar.current.isDateInToday(saved!))
    }

    func testMultipleRecordActivityCallsAccumulate() {
        let vm = makeViewModel()
        vm.recordActivity()
        vm.recordActivity()
        vm.recordActivity()
        XCTAssertEqual(localRepo.loadStreakCount(), 3)
        XCTAssertEqual(vm.streak, "🔥 3 days")
    }

    func testClearStreakResetsDisplayToZero() {
        localRepo.saveStreakCount(8)
        let vm = makeViewModel()
        vm.clearStreak()
        XCTAssertEqual(vm.streak, "🔥 0 days")
    }

    func testClearStreakWipesStoredCount() {
        localRepo.saveStreakCount(8)
        let vm = makeViewModel()
        vm.clearStreak()
        XCTAssertEqual(localRepo.loadStreakCount(), 0)
    }

    func testClearStreakRemovesLastDate() {
        localRepo.saveLastStreakDate(Date())
        localRepo.saveStreakCount(3)
        let vm = makeViewModel()
        vm.clearStreak()
        XCTAssertNil(localRepo.loadLastStreakDate())
    }

    private func waitForCourse(
        in vm: HomeViewModel,
        timeoutNanoseconds: UInt64 = 500_000_000
    ) async throws -> Bool {
        let start = DispatchTime.now().uptimeNanoseconds
        while vm.activeCourse == nil {
            if DispatchTime.now().uptimeNanoseconds - start > timeoutNanoseconds { return false }
            try await Task.sleep(nanoseconds: 10_000_000)
        }
        return true
    }
}
