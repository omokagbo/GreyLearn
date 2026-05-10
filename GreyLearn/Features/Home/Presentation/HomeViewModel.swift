//
// HomeViewModel.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/10/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.

import SwiftUI
import Combine

final class HomeViewModel: ObservableObject {
    @Published var activeCourse: Course? = nil
    @Published var streak: String = ""
    private let repository: CourseRepository
    private let localRepo: LocalRepository

    init(repository: CourseRepository, localRepository: LocalRepository) {
        self.repository = repository
        self.localRepo = localRepository
    }
    
    func getCourse() {
        Task {
            do {
                let course = try await repository.fetchActiveCourse()
                await MainActor.run {
                    activeCourse = course
                    saveStreak()
                }
            } catch {
                
            }
        }
    }
    
    func getStreak() {
        //let streaks = localRepo.retrieveStreaks()
        //let streakCount = streaks.count
        //streak = "🔥 \(streakCount) \(streakCount == 1 ? "day" : "days")"
    }
    
    func saveStreak() {
        //let completedModules = activeCourse?.modules ?? []
//        let streaks: [Streak] = completedModules.compactMap {
//            Streak(id: $0.id, date: $0.dateCompleted ?? "")
//        }
        
        //localRepo.saveStreaks(streaks)
    }
}
