// Core/Date+Extension.swift
import Foundation

public extension Date {
    /// Returns a date offset by the given number of days from today.
    static func daysFromNow(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: Date()) ?? Date()
    }

    /// Returns a greeting string based on the current hour.
    var timeOfDayGreeting: String {
        let hour = Calendar.current.component(.hour, from: self)
        switch hour {
        case 5..<12:  return "Good morning"
        case 12..<17: return "Good afternoon"
        case 17..<23: return "Good evening"
        default:      return "Good night"
        }
    }

    /// Returns a personalised greeting for the given name.
    func greeting(withName name: String) -> String {
        "\(timeOfDayGreeting) \(name)!"
    }
}
