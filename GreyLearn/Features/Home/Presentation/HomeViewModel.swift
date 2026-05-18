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

    init(dependencies: HomeDependencies = .mock) {
        self.repository = dependencies.courseRepository
        self.localRepo  = dependencies.localRepository
        let saved = dependencies.localRepository.loadStreakCount()
        streak = Self.format(count: saved)
    }


    func getCourse() {
        Task {
            do {
                let course = try await repository.fetchActiveCourse()
                await MainActor.run { activeCourse = course }
            } catch {}
        }
    }

    /// Call on every home screen appear.
    /// - Same day  → show persisted count unchanged.
    /// - Yesterday → streak intact, mark today as active, show persisted count.
    /// - 2+ days ago → reset to 0.
    /// - No prior date → first launch, start at 0.
    func getStreak() {
        let calendar  = Calendar.current
        let today     = calendar.startOfDay(for: Date())
        let lastDate  = localRepo.loadLastStreakDate()
        let saved     = localRepo.loadStreakCount()

        guard let last = lastDate else {
            // Very first launch
            localRepo.saveLastStreakDate(today)
            localRepo.saveStreakCount(0)
            updateDisplay(0)
            return
        }

        let lastDay       = calendar.startOfDay(for: last)
        let daysSinceLast = calendar.dateComponents([.day], from: lastDay, to: today).day ?? 0

        switch daysSinceLast {
        case 0:
            // Same day — never overwrite, just show what's already saved
            updateDisplay(saved)
        case 1:
            // Came back the next day — mark today without changing count
            localRepo.saveLastStreakDate(today)
            updateDisplay(saved)
        default:
            // Missed a day or more — reset
            localRepo.saveStreakCount(0)
            localRepo.saveLastStreakDate(today)
            updateDisplay(0)
        }
    }

    /// Records a learning activity — increments and persists the streak immediately.
    /// Hook into real lesson/module completion when ready.
    func recordActivity() {
        let newCount = localRepo.loadStreakCount() + 1
        localRepo.saveStreakCount(newCount)
        localRepo.saveLastStreakDate(Calendar.current.startOfDay(for: Date()))
        updateDisplay(newCount)
    }

    /// Wipes streak data and resets display to 0.
    func clearStreak() {
        localRepo.clearStreak()
        updateDisplay(0)
    }

    private func updateDisplay(_ count: Int) {
        streak = Self.format(count: count)
    }

    private static func format(count: Int) -> String {
        "🔥 \(count) \(count == 1 ? "day" : "days")"
    }
}
