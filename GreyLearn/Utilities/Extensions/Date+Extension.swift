//
// Date+Extension.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/10/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.

import Foundation

extension Date {
    static func daysFromNow(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: Date()) ?? Date()
    }
    
    var timeOfDayGreeting: String {
        let hour = Calendar.current.component(.hour, from: self)
        
        switch hour {
        case 3..<5:
            return "Go to bed"
        case 5..<12:
            return "Good morning"
        case 12..<17:
            return "Good afternoon"
        case 17..<22:
            return "Good evening"
        default:
            return "Hello"
        }
    }
    
    func greeting(withName name: String) -> String {
        "\(timeOfDayGreeting) \(name)!"
    }
}
