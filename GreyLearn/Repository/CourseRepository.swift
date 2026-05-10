//
// CourseRepository.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/10/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.

import Foundation

protocol CourseRepository {
    func fetchActiveCourse() async throws -> Course
}

struct MockCourseRepository: CourseRepository {
    let delayNanoseconds: UInt64

    init(delayNanoseconds: UInt64 = 1_000_000_000) {
        self.delayNanoseconds = delayNanoseconds
    }

    func fetchActiveCourse() async throws -> Course {
        try await Task.sleep(nanoseconds: delayNanoseconds)
        return Course.mockCourse
    }
}
