//
// CourseTests.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/10/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.

import XCTest
import Domain

final class CourseTests: XCTestCase {
    func testCourseStageProgressFromMockData() {
        let stage = Course.mockCourse.stage
        XCTAssertEqual(stage.text, "Stage 3 of 11")
        XCTAssertEqual(stage.progress, 3.0 / 11.0, accuracy: 0.0001)
    }
}
