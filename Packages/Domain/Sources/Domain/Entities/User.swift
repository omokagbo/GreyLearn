// Domain/Entities/User.swift
import Foundation
import Core

public struct User: Codable, Identifiable {
    public let id: UUID
    public var firstName: String
    public var lastName: String
    public var email: String
    public var profileImageURL: URL?
    public var status: UserStatus
    public let createdAt: Date
    public var updatedAt: Date

    public init(
        id: UUID,
        firstName: String,
        lastName: String,
        email: String,
        profileImageURL: URL? = nil,
        status: UserStatus,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.profileImageURL = profileImageURL
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

public enum UserStatus: Int, Codable, CaseIterable {
    case active, inactive, suspended
}

public extension User {
    var fullName: String { "\(firstName) \(lastName)" }

    var initials: String {
        firstName.firstLetter + lastName.firstLetter
    }

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
