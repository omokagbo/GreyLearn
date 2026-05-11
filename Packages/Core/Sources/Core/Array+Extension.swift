// Core/Array+Extension.swift
import Foundation

public extension Array {
    /// Splits the array into chunks of the given size.
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map { start in
            Array(self[start..<Swift.min(start + size, count)])
        }
    }
}
