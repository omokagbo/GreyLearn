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
    /// Records today if not already recorded, resets if yesterday was missed, then refreshes the display.
    func getStreak() {
        var entries = localRepo.retrieveStreaks()

        let calendar = Calendar.current
        let today    = calendar.startOfDay(for: Date())

        // Already recorded today — just refresh display
        if entries.contains(where: { calendar.isDateInToday($0.date) }) {
            refreshStreakDisplay(entries: entries)
            return
        }

        // Check if the last entry was yesterday — if not, streak is broken → reset
        let lastEntry = entries.max(by: { $0.date < $1.date })
        if let last = lastEntry {
            let daysSinceLast = calendar.dateComponents([.day], from: calendar.startOfDay(for: last.date), to: today).day ?? 0
            if daysSinceLast > 1 {
                // Missed at least one day — reset
                entries = []
            }
        }

        // Record today
        entries.append(Streak(date: today))
        localRepo.saveStreaks(entries)
        refreshStreakDisplay(entries: entries)
    }

    /// Call this when a user completes a learning activity to increment the streak.
    func recordActivity() {
        // TODO: Hook this into lesson/module completion events.
        // Currently streak grows from daily app launches.
        // When wiring up, call localRepo.saveStreaks() with an updated entry for today.
    }

    // MARK: - Private

    private func refreshStreakDisplay(entries: [Streak]) {
        // Count only consecutive days up to and including today
        let calendar  = Calendar.current
        let today     = calendar.startOfDay(for: Date())
        let sortedDays = entries
            .map { calendar.startOfDay(for: $0.date) }
            .sorted(by: >)  // most recent first

        var count    = 0
        var expected = today

        for day in sortedDays {
            if day == expected {
                count   += 1
                expected = calendar.date(byAdding: .day, value: -1, to: expected)!
            } else {
                break
            }
        }

        streak = "🔥 \(count)"
    }
}
