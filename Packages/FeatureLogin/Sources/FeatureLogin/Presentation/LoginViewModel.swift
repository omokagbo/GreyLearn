// FeatureLogin/Presentation/LoginViewModel.swift
import SwiftUI
import Combine
import Domain

public final class LoginViewModel: ObservableObject {
    @Published public var firstName: String = ""
    @Published public var lastName:  String = ""
    @Published public var email:     String = ""

    @Published public var firstNameError: String? = nil
    @Published public var lastNameError:  String? = nil
    @Published public var emailError:     String? = nil
    @Published public var isLoading: Bool = false

    private var cancellables = Set<AnyCancellable>()

    public init() {
        $firstName
            .dropFirst()
            .map { $0.trimmingCharacters(in: .whitespaces).isEmpty ? "First name is required" : nil }
            .sink { [weak self] in self?.firstNameError = $0 }
            .store(in: &cancellables)

        $lastName
            .dropFirst()
            .map { $0.trimmingCharacters(in: .whitespaces).isEmpty ? "Last name is required" : nil }
            .sink { [weak self] in self?.lastNameError = $0 }
            .store(in: &cancellables)

        $email
            .dropFirst()
            .map { value -> String? in
                let trimmed = value.trimmingCharacters(in: .whitespaces)
                if trimmed.isEmpty { return "Email is required" }
                guard let regex = try? NSRegularExpression(
                    pattern: #"^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$"#
                ) else { return nil }
                let range = NSRange(trimmed.startIndex..., in: trimmed)
                return regex.firstMatch(in: trimmed, range: range) == nil
                    ? "Enter a valid email address" : nil
            }
            .sink { [weak self] in self?.emailError = $0 }
            .store(in: &cancellables)
    }

    public var isFormValid: Bool {
        let firstNameOk  = !firstName.trimmingCharacters(in: .whitespaces).isEmpty
        let lastNameOk   = !lastName.trimmingCharacters(in: .whitespaces).isEmpty
        return firstNameOk && lastNameOk && isValidEmail(email)
    }

    @discardableResult
    public func validateAll() -> Bool {
        firstNameError = firstName.trimmingCharacters(in: .whitespaces).isEmpty ? "First name is required" : nil
        lastNameError  = lastName.trimmingCharacters(in: .whitespaces).isEmpty  ? "Last name is required"  : nil
        let trimmed = email.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty {
            emailError = "Email is required"
        } else {
            emailError = isValidEmail(trimmed) ? nil : "Enter a valid email address"
        }
        return firstNameError == nil && lastNameError == nil && emailError == nil
    }

    public func signIn(onSuccess: @escaping (User) -> Void) {
        guard validateAll() else { return }
        isLoading = true
        let user = buildUser()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.isLoading = false
            onSuccess(user)
        }
    }

    public func buildUser() -> User {
        User(
            id: UUID(),
            firstName: firstName.trimmingCharacters(in: .whitespaces),
            lastName:  lastName.trimmingCharacters(in: .whitespaces),
            email:     email.trimmingCharacters(in: .whitespaces),
            profileImageURL: nil,
            status: .active,
            createdAt: Date(),
            updatedAt: Date()
        )
    }

    // MARK: - Private

    private func isValidEmail(_ value: String) -> Bool {
        let trimmed = value.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty,
              let regex = try? NSRegularExpression(
                pattern: #"^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$"#
              ) else { return false }
        let range = NSRange(trimmed.startIndex..., in: trimmed)
        return regex.firstMatch(in: trimmed, range: range) != nil
    }
}
