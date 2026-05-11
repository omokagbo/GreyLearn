//
// ModuleTests.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/10/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.

import XCTest
import Domain

final class ModuleTests: XCTestCase {

    func testModuleBadgeIconMatchesStatus() {
        let completed  = Course.mockCourse.modules.first { $0.completionStatus == .completed }
        let inProgress = Course.mockCourse.modules.first { $0.completionStatus == .inProgress }
        let locked     = Course.mockCourse.modules.first { $0.completionStatus == .locked }

        XCTAssertEqual(completed?.badgeIcon,  "purple-badge")
        XCTAssertEqual(inProgress?.badgeIcon, "blue-badge")
        XCTAssertEqual(locked?.badgeIcon,     "grey-badge")
    }
}
