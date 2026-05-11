// Domain/Entities/Course.swift
import Foundation
import Core

public struct Course: Codable, Hashable {
    public let id: String
    public let name: String
    public let description: String
    public let modules: [Module]
    public let isActive: Bool
    public let isDeleted: Bool
    public let createdAt: Date
    public let updatedAt: Date

    public enum CodingKeys: String, CodingKey {
        case id, name, description, modules, isActive, isDeleted, createdAt, updatedAt
    }

    public init(
        id: String,
        name: String,
        description: String,
        modules: [Module],
        isActive: Bool,
        isDeleted: Bool,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.modules = modules
        self.isActive = isActive
        self.isDeleted = isDeleted
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    /// Returns the current stage text and progress fraction (0–1).
    public var stage: (text: String, progress: Float) {
        let lockedCount  = modules.count(where: { $0.completionStatus == .locked })
        let totalCount   = modules.count
        let unlockedCount = totalCount - lockedCount
        let progress     = Float(unlockedCount) / Float(totalCount)
        let stageText    = "Stage \(unlockedCount) of \(totalCount)"
        return (stageText, progress)
    }
}

public extension Course {
    static let mockCourseIntId = 1

    static let mockCourse = Course(
        id: UUID().uuidString,
        name: "Fullstack Mobile Engineer",
        description: "A step-by-step curated learning journey covering fundamentals, UI, backend, testing, and publishing.",
        modules: [
            Module(id: 1, name: "Programming Basics",
                   description: "Introduction to programming concepts, syntax, and problem solving.",
                   completionStatus: .completed,
                   completionTitle: "Basics, nahh, we up now!",
                   completionCheer: "Versioned & valiant. You don't just write code. You commit to it.",
                   duration: 120, price: 0.0,
                   sections: [Section(id: 11, name: "Programming Fundamentals", topics: [
                       Topic(id: 111, courseId: mockCourseIntId, name: "Variables & Types", description: "Learn basic types and how variables work.", isCompleted: true, dueDate: .daysFromNow(-7)),
                       Topic(id: 112, courseId: mockCourseIntId, name: "Control Flow Practice", description: "Work with if/else, switch, and loops.", isCompleted: true, dueDate: .daysFromNow(-6))
                   ], isCompleted: true)],
                   dateStarted: "22/02/2026", dateCompleted: "22/02/2026"),

            Module(id: 2, name: "Git & Version Control",
                   description: "Learn Git basics, branching, merging, and collaboration.",
                   completionStatus: .completed,
                   completionTitle: "Git & version control mastery earned",
                   completionCheer: "Versioned & valiant. You don't just write code. You commit to it.",
                   duration: 90, price: 0.0,
                   sections: [Section(id: 21, name: "Git Essentials", topics: [
                       Topic(id: 211, courseId: mockCourseIntId, name: "Initialize a Repo & Commit", description: "Create a repo and make your first commit.", isCompleted: true, dueDate: .daysFromNow(-5)),
                       Topic(id: 212, courseId: mockCourseIntId, name: "Branching & Merging", description: "Create branches and merge changes safely.", isCompleted: true, dueDate: .daysFromNow(-4))
                   ], isCompleted: true)],
                   dateStarted: "23/02/2026", dateCompleted: "23/02/2026"),

            Module(id: 3, name: "Learn React",
                   description: "JSX, components, state, props, and lifecycle fundamentals.",
                   completionStatus: .inProgress,
                   completionTitle: "",
                   completionCheer: "Versioned & valiant. You don't just write code. You commit to it.",
                   duration: 180, price: 0.0,
                   sections: [
                       Section(id: 31, name: "Component lifecycle", topics: [
                           Topic(id: 311, courseId: mockCourseIntId, name: "Build a login screen in React", description: "Create a simple login screen using functional components, state, and basic validation.", isCompleted: false, dueDate: .daysFromNow(1)),
                           Topic(id: 312, courseId: mockCourseIntId, name: "Refactor login to use useEffect", description: "Add lifecycle behavior (e.g. form state sync, side effects) using useEffect.", isCompleted: false, dueDate: .daysFromNow(2))
                       ], isCompleted: false),
                       Section(id: 32, name: "State & Props", topics: [
                           Topic(id: 321, courseId: mockCourseIntId, name: "Pass props between components", description: "Split UI into smaller components and pass data via props.", isCompleted: false, dueDate: .daysFromNow(3))
                       ], isCompleted: false)
                   ],
                   dateStarted: "24/02/2026", dateCompleted: nil),

            Module(id: 4, name: "Core Mobile UI Build",
                   description: "Build mobile UI screens and learn layout fundamentals.",
                   completionStatus: .locked, completionTitle: "",
                   completionCheer: "Versioned & valiant. You don't just write code. You commit to it.",
                   duration: 200, price: 0.0,
                   sections: [Section(id: 41, name: "Layouts", topics: [
                       Topic(id: 411, courseId: mockCourseIntId, name: "Recreate a simple dashboard UI", description: "Build a clean UI layout using stacks and spacing.", isCompleted: false, dueDate: .daysFromNow(5))
                   ], isCompleted: false)],
                   dateStarted: nil, dateCompleted: nil),

            Module(id: 5, name: "Access Device Features",
                   description: "Use device features like camera, location, storage, and permissions.",
                   completionStatus: .locked, completionTitle: "",
                   completionCheer: "Versioned & valiant. You don't just write code. You commit to it.",
                   duration: 150, price: 0.0,
                   sections: [Section(id: 51, name: "Core Features", topics: [
                       Topic(id: 511, courseId: mockCourseIntId, name: "Access camera and display image", description: "Pick/take an image and preview it in the app.", isCompleted: false, dueDate: .daysFromNow(7))
                   ], isCompleted: false)],
                   dateStarted: nil, dateCompleted: nil),

            Module(id: 6, name: "Navigations and Forms",
                   description: "Navigation flows and building forms with validation.",
                   completionStatus: .locked, completionTitle: "",
                   completionCheer: "Versioned & valiant. You don't just write code. You commit to it.",
                   duration: 140, price: 0.0,
                   sections: [Section(id: 61, name: "Navigation", topics: [
                       Topic(id: 611, courseId: mockCourseIntId, name: "Implement navigation between screens", description: "Set up navigation and route to details pages.", isCompleted: false, dueDate: .daysFromNow(9))
                   ], isCompleted: false)],
                   dateStarted: nil, dateCompleted: nil),

            Module(id: 7, name: "Node.js & Express",
                   description: "Backend fundamentals using Node.js and Express.",
                   completionStatus: .locked, completionTitle: "",
                   completionCheer: "Versioned & valiant. You don't just write code. You commit to it.",
                   duration: 200, price: 0.0,
                   sections: [Section(id: 71, name: "Backend Basics", topics: [
                       Topic(id: 711, courseId: mockCourseIntId, name: "Create a REST endpoint", description: "Build a simple GET/POST endpoint for users.", isCompleted: false, dueDate: .daysFromNow(12))
                   ], isCompleted: false)],
                   dateStarted: nil, dateCompleted: nil),

            Module(id: 8, name: "Backend Architecture",
                   description: "Learn scalable backend patterns and structure.",
                   completionStatus: .locked, completionTitle: "",
                   completionCheer: "Versioned & valiant. You don't just write code. You commit to it.",
                   duration: 210, price: 0.0,
                   sections: [Section(id: 81, name: "Architecture Planning", topics: [
                       Topic(id: 811, courseId: mockCourseIntId, name: "Design a simple service layer", description: "Separate handlers, services, and repositories.", isCompleted: false, dueDate: .daysFromNow(15))
                   ], isCompleted: false)],
                   dateStarted: nil, dateCompleted: nil),

            Module(id: 9, name: "Authentication & Authorization",
                   description: "Secure auth, tokens, sessions, and permissions.",
                   completionStatus: .locked, completionTitle: "",
                   completionCheer: "Versioned & valiant. You don't just write code. You commit to it.",
                   duration: 170, price: 0.0,
                   sections: [Section(id: 91, name: "Security Basics", topics: [
                       Topic(id: 911, courseId: mockCourseIntId, name: "Implement JWT login flow", description: "Authenticate and store a token securely.", isCompleted: false, dueDate: .daysFromNow(18))
                   ], isCompleted: false)],
                   dateStarted: nil, dateCompleted: nil),

            Module(id: 10, name: "Write and Run Tests",
                   description: "Unit tests, UI tests, and mocking strategies.",
                   completionStatus: .locked, completionTitle: "",
                   completionCheer: "Versioned & valiant. You don't just write code. You commit to it.",
                   duration: 120, price: 0.0,
                   sections: [Section(id: 101, name: "Testing Essentials", topics: [
                       Topic(id: 1011, courseId: mockCourseIntId, name: "Write a unit test for login validation", description: "Test input validation rules and error states.", isCompleted: false, dueDate: .daysFromNow(21))
                   ], isCompleted: false)],
                   dateStarted: nil, dateCompleted: nil),

            Module(id: 11, name: "Publish Your Mobile App",
                   description: "Prepare, release, and maintain your app.",
                   completionStatus: .locked, completionTitle: "",
                   completionCheer: "Versioned & valiant. You don't just write code. You commit to it.",
                   duration: 240, price: 0.0,
                   sections: [Section(id: 111, name: "Deployment", topics: [
                       Topic(id: 1111, courseId: mockCourseIntId, name: "Prepare for App Store submission", description: "Screenshots, metadata, signing, and release checklist.", isCompleted: false, dueDate: .daysFromNow(28))
                   ], isCompleted: false)],
                   dateStarted: nil, dateCompleted: nil),
        ],
        isActive: true,
        isDeleted: false,
        createdAt: .daysFromNow(-30),
        updatedAt: Date()
    )
}
