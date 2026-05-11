// FeatureHome/Presentation/HomeViewModel.swift
import SwiftUI
import Combine
import Domain

public final class HomeViewModel: ObservableObject {
    @Published public var activeCourse: Course? = nil
    @Published public var streak: String = ""

    private let repository: CourseRepository
    private let localRepo: LocalRepository

    public init(dependencies: HomeDependencies = .live) {
        self.repository = dependencies.courseRepository
        self.localRepo  = dependencies.localRepository
        let saved = dependencies.localRepository.loadStreakCount()
        streak = Self.format(count: saved)
    }

    public func getCourse() {
        Task {
            do {
                let course = try await repository.fetchActiveCourse()
                await MainActor.run { activeCourse = course }
            } catch {}
        }
    }

    public func getStreak() {
        let calendar  = Calendar.current
        let today     = calendar.startOfDay(for: Date())
        let lastDate  = localRepo.loadLastStreakDate()
        let saved     = localRepo.loadStreakCount()

        guard let last = lastDate else {
            localRepo.saveLastStreakDate(today)
            localRepo.saveStreakCount(0)
            updateDisplay(0)
            return
        }

        let lastDay       = calendar.startOfDay(for: last)
        let daysSinceLast = calendar.dateComponents([.day], from: lastDay, to: today).day ?? 0

        switch daysSinceLast {
        case 0:
            updateDisplay(saved)
        case 1:
            localRepo.saveLastStreakDate(today)
            updateDisplay(saved)
        default:
            localRepo.saveStreakCount(0)
            localRepo.saveLastStreakDate(today)
            updateDisplay(0)
        }
    }

    public func recordActivity() {
        let newCount = localRepo.loadStreakCount() + 1
        localRepo.saveStreakCount(newCount)
        localRepo.saveLastStreakDate(Calendar.current.startOfDay(for: Date()))
        updateDisplay(newCount)
    }

    public func clearStreak() {
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
