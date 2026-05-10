//
// User.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/10/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.
	
import SwiftUI

struct User: Codable, Identifiable {
    let id: UUID
    var firstName: String
    var lastName: String
    var email: String
    var profileImageURL: URL?
    var status: UserStatus
    let createdAt: Date
    var updatedAt: Date
}

enum UserStatus: Int, Codable, CaseIterable {
    case active, inactive, suspended
}

extension User {
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    var initials: String {
        let first = firstName.firstLetter
        let last  = lastName.firstLetter
        return first + last
    }
}

extension User {
    static let user = User(
        id: UUID(),
        firstName: "Emmanuel",
        lastName: "Omokagbo",
        email: "emmanuel@omokagbo.com",
        profileImageURL: nil,
        status: .active,
        createdAt: Date(),
        updatedAt: Date()
    )
}
