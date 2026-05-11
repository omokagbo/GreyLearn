// Core/String+Extension.swift
import Foundation

public extension String {
    /// Returns the first letter of the string, uppercased, or an empty string.
    var firstLetter: String {
        self.first.map { String($0).uppercased() } ?? ""
    }
}
