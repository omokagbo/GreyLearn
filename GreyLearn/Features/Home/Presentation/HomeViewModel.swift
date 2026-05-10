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
        self.localRepo  = localRepository
    }

    // MARK: - Course

    func getCourse() {
        Task {
            do {
                let course = try await repository.fetchActiveCourse()
                await MainActor.run {
                    activeCourse = course
                }
            } catch {}
        }
    }

    // MARK: - Streak

    /// Called on every app launch / home screen appear.
    /// - If today already recorded: just display the saved count.
    /// - If last active was yesterday: streak is intact, display saved count.
    /// - If last active was 2+ days ago: reset to 0.
    /// - If never launched before: start at 0.
    func getStreak() {
        let calendar     = Calendar.current
        let today        = calendar.startOfDay(for: Date())
        let savedCount   = localRepo.loadStreakCount()
        let lastDate     = localRepo.loadLastStreakDate()

        if let last = lastDate {
            let lastDay      = calendar.startOfDay(for: last)
            let daysSinceLast = calendar.dateComponents([.day], from: lastDay, to: today).day ?? 0

            switch daysSinceLast {
            case 0:
                // Same day — already recorded, just refresh display
                updateDisplay(count: savedCount)
            case 1:
                // Yesterday — streak intact, update lastDate to today
                localRepo.saveLastStreakDate(today)
                updateDisplay(count: savedCount)
            default:
                // Missed one or more days — reset
                localRepo.saveStreakCount(0)
                localRepo.saveLastStreakDate(today)
                updateDisplay(count: 0)
            }
        } else {
            // First ever launch — start at 0
            localRepo.saveLastStreakDate(today)
            localRepo.saveStreakCount(0)
            updateDisplay(count: 0)
        }
    }

    /// Simulates / records a learning activity.
    /// Each call increments the streak by 1 and persists immediately.
    /// Hook into real lesson/module completion when ready.
    func recordActivity() {
        let newCount = localRepo.loadStreakCount() + 1
        localRepo.saveStreakCount(newCount)
        localRepo.saveLastStreakDate(Calendar.current.startOfDay(for: Date()))
        updateDisplay(count: newCount)
    }

    /// Wipes streak data and resets display to 0.
    func clearStreak() {
        localRepo.clearStreak()
        updateDisplay(count: 0)
    }

    // MARK: - Private

    private func updateDisplay(count: Int) {
        streak = "🔥 \(count) \(count < 2 ? "day" : "days")"
    }
}
