// Domain/Entities/Module.swift
import Foundation

public struct Module: Codable, Hashable, Identifiable {
    public let id: Int
    public let name: String
    public let description: String
    public let completionStatus: ModuleStatus
    public let completionTitle: String
    public let completionCheer: String
    public let duration: Int
    public let price: Double
    public let sections: [Section]
    public let dateStarted: String?
    public let dateCompleted: String?

    public enum CodingKeys: String, CodingKey {
        case id, name, description, completionStatus, completionTitle, completionCheer,
             duration, price, sections, dateStarted, dateCompleted
    }

    public init(
        id: Int,
        name: String,
        description: String,
        completionStatus: ModuleStatus,
        completionTitle: String,
        completionCheer: String,
        duration: Int,
        price: Double,
        sections: [Section],
        dateStarted: String?,
        dateCompleted: String?
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.completionStatus = completionStatus
        self.completionTitle = completionTitle
        self.completionCheer = completionCheer
        self.duration = duration
        self.price = price
        self.sections = sections
        self.dateStarted = dateStarted
        self.dateCompleted = dateCompleted
    }

    public var badgeIcon: String {
        switch completionStatus {
        case .completed:  return "purple-badge"
        case .inProgress: return "blue-badge"
        case .locked:     return "grey-badge"
        }
    }

    public var shareMessage: String {
        """
        🎉 \(completionTitle)
        \(completionCheer)

        I just completed the "\(name)" module!
        #LearningJourney #Grey
        """
    }
}

public struct Section: Codable, Hashable {
    public let id: Int
    public let name: String
    public let topics: [Topic]
    public let isCompleted: Bool

    public init(id: Int, name: String, topics: [Topic], isCompleted: Bool) {
        self.id = id
        self.name = name
        self.topics = topics
        self.isCompleted = isCompleted
    }
}

public struct Topic: Codable, Hashable {
    public let id: Int
    public let courseId: Int
    public let name: String
    public let description: String
    public let isCompleted: Bool
    public let dueDate: Date

    public init(id: Int, courseId: Int, name: String, description: String, isCompleted: Bool, dueDate: Date) {
        self.id = id
        self.courseId = courseId
        self.name = name
        self.description = description
        self.isCompleted = isCompleted
        self.dueDate = dueDate
    }
}

public enum ModuleStatus: Int, Codable, Hashable {
    case completed
    case inProgress
    case locked
}
