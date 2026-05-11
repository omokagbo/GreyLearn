// Domain/Entities/Streak.swift
import Foundation

public struct Streak: Codable {
    /// The calendar day this streak entry represents (time component is ignored).
    public let date: Date

    public init(date: Date) {
        self.date = date
    }

    /// Returns true if this entry represents today.
    public var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }

    /// Returns true if this entry represents yesterday.
    public var isYesterday: Bool {
        Calendar.current.isDateInYesterday(date)
    }
}
