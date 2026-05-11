// Domain/Repository/CourseRepository.swift
import Foundation

public protocol CourseRepository {
    func fetchActiveCourse() async throws -> Course
}

public struct MockCourseRepository: CourseRepository {
    public let delayNanoseconds: UInt64

    public init(delayNanoseconds: UInt64 = 1_000_000_000) {
        self.delayNanoseconds = delayNanoseconds
    }

    public func fetchActiveCourse() async throws -> Course {
        try await Task.sleep(nanoseconds: delayNanoseconds)
        return Course.mockCourse
    }
}
