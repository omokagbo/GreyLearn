//
// CouseRepositoryTests.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/10/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.

import XCTest
import Domain

@MainActor
final class CouseRepositoryTests: XCTestCase {

    func testMockRepositoryReturnsMockCourse() async throws {
        let repository = MockCourseRepository(delayNanoseconds: 0)
        let course = try await repository.fetchActiveCourse()
        XCTAssertEqual(course, Course.mockCourse)
    }
}
