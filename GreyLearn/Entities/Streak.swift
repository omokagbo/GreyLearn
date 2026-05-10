//
//  Streak.swift
//  GreyLearn
//
//  Created by Emmanuel Omokagbo on 5/10/26.
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.
//

import Foundation

struct Streak: Codable {
    /// The calendar day this streak entry represents (time component is ignored).
    let date: Date

    /// Returns true if this entry represents today.
    var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }

    /// Returns true if this entry represents yesterday.
    var isYesterday: Bool {
        Calendar.current.isDateInYesterday(date)
    }
}
