// FeatureLogin/DI/LoginDependencies.swift
import Foundation

public struct LoginDependencies {
    public let viewModel: LoginViewModel

    public init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }

    public static var live: LoginDependencies {
        LoginDependencies(viewModel: LoginViewModel())
    }
}
