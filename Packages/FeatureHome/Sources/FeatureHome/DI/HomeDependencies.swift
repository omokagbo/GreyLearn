// FeatureHome/DI/HomeDependencies.swift
import Foundation
import Domain

public struct HomeDependencies {
    public let courseRepository: CourseRepository
    public let localRepository: LocalRepository

    public init(courseRepository: CourseRepository, localRepository: LocalRepository) {
        self.courseRepository = courseRepository
        self.localRepository  = localRepository
    }

    public static let live = HomeDependencies(
        courseRepository: MockCourseRepository(),
        localRepository: LocalRepository()
    )
}
