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
    @Published var isLoading: Bool = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        $firstName
            .dropFirst()
            .map { value -> String? in
                value.trimmingCharacters(in: .whitespaces).isEmpty ? "First name is required" : nil
            }
            .assign(to: &$firstNameError)

        $lastName
            .dropFirst()
            .map { value -> String? in
                value.trimmingCharacters(in: .whitespaces).isEmpty ? "Last name is required" : nil
            }
            .assign(to: &$lastNameError)

        $email
            .dropFirst()
            .map { value -> String? in
                let trimmed = value.trimmingCharacters(in: .whitespaces)
                if trimmed.isEmpty { return "Email is required" }
                let regex = /^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$/
                return trimmed.wholeMatch(of: regex) == nil ? "Enter a valid email address" : nil
            }
            .assign(to: &$emailError)
    }

    var isFormValid: Bool {
        let firstNameOk = !firstName.trimmingCharacters(in: .whitespaces).isEmpty
        let lastNameOk = !lastName.trimmingCharacters(in: .whitespaces).isEmpty
        let trimmedEmail = email.trimmingCharacters(in: .whitespaces)
        let regex = /^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$/
        let emailOk = trimmedEmail.wholeMatch(of: regex) != nil
        return firstNameOk && lastNameOk && emailOk
    }

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

    func signIn(onSuccess: @escaping (User) -> Void) {
        guard validateAll() else { return }
        isLoading = true
        let user = buildUser()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.isLoading = false
            onSuccess(user)
        }
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
