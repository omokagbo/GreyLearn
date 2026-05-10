//
// LocalRepository.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/10/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.

import Foundation

struct LocalRepository {
    let defaults: UserDefaults
    
    init(defaults: UserDefaults = UserDefaults.standard) {
        self.defaults = defaults
    }
    
//    func retrieveStreaks() -> [Streak] {
//        let streaks = defaults.object(forKey: "streaks")
//        let decoder = JSONDecoder()
//        let data = try? decoder.decode([Streak].self, from: streaks)
//        return streaks
//    }
//    
//    func saveStreaks(_ streaks: [Streak]) {
//        let existingStreak = retrieveStreaks()
//        let newStreaks = existingStreak + streaks
//        let encoder: JSONEncoder = JSONEncoder()
//        let data = try? encoder.encode(newStreaks)
//        defaults.setValue(newStreaks, forKey: "streaks")
//    }
}
