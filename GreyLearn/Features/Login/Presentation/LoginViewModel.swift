//
// LoginViewModel.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/10/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.

import SwiftUI
import Combine

final class LoginViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""

    @Published var firstNameError: String? = nil
    @Published var lastNameError: String? = nil
    @Published var emailError: String? = nil

    var isValid: Bool {
        validateAll()
        return firstNameError == nil && lastNameError == nil && emailError == nil
    }

    @discardableResult
    func validateAll() -> Bool {
        firstNameError = firstName.trimmingCharacters(in: .whitespaces).isEmpty
            ? "First name is required" : nil
        lastNameError = lastName.trimmingCharacters(in: .whitespaces).isEmpty
            ? "Last name is required" : nil
        emailError = {
            let trimmed = email.trimmingCharacters(in: .whitespaces)
            if trimmed.isEmpty { return "Email is required" }
            let regex = /^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$/
            return trimmed.wholeMatch(of: regex) == nil ? "Enter a valid email address" : nil
        }()
        return firstNameError == nil && lastNameError == nil && emailError == nil
    }

    func buildUser() -> User {
        User(
            id: UUID(),
            firstName: firstName.trimmingCharacters(in: .whitespaces),
            lastName: lastName.trimmingCharacters(in: .whitespaces),
            email: email.trimmingCharacters(in: .whitespaces),
            profileImageURL: nil,
            status: .active,
            createdAt: Date(),
            updatedAt: Date()
        )
    }
}
