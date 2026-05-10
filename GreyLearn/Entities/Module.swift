//
// Module.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/10/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.

import Foundation

struct Module: Codable, Hashable, Identifiable {
    let id: Int
    let name: String
    let description: String
    let completionStatus: ModuleStatus
    let completionTitle: String
    let completionCheer: String
    let duration: Int
    let price: Double
    let sections: [Section]
    let dateStarted: String?
    let dateCompleted: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, completionStatus, completionTitle, completionCheer, duration, price, sections, dateStarted, dateCompleted
    }
    
    var badgeIcon: String {
        switch completionStatus {
        case .completed: return "purple-badge"
        case .inProgress: return "blue-badge"
        case .locked: return "grey-badge"
        }
    }
}

struct Section: Codable, Hashable {
    let id: Int
    let name: String
    let topics: [Topic]
    let isCompleted: Bool
}

struct Topic: Codable, Hashable {
    let id: Int
    let courseId: Int
    let name: String
    let description: String
    let isCompleted: Bool
    let dueDate: Date
}

enum ModuleStatus: Int, Codable, Hashable {
    case completed
    case inProgress
    case locked
}

extension Module {
    var shareMessage: String {
        """
        🎉 \(completionTitle)
        \(completionCheer)

        I just completed the "\(name)" module!
        #LearningJourney #Grey
        """
    }
}
