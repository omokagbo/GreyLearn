// FeatureHome/Presentation/HomeView.swift
import SwiftUI
import AppCoordination
import Domain
import DesignSystem

public struct HomeView: View {
    @Environment(HomeCoordinator.self) private var homeCoordinator
    @StateObject private var viewModel: HomeViewModel
    private let user: User

    private var currentModule: Module? {
        viewModel.activeCourse?.modules.first(where: { $0.completionStatus == .inProgress })
    }
    private var currentSection: Domain.Section? {
        currentModule?.sections.first(where: { !$0.isCompleted })
    }
    private var activeTopic: Topic? {
        currentSection?.topics.first(where: { !$0.isCompleted })
    }

    public init(user: User, dependencies: HomeDependencies = .live) {
        self.user = user
        _viewModel = StateObject(wrappedValue: HomeViewModel(dependencies: dependencies))
    }

    public var body: some View {
        // NOTE: NavigationStack is owned by the main app (GreyLearnApp / AppRouteView).
        // HomeView provides only the scrollable content so that feature packages
        // do not need to import the main app target.
        ScrollView {
            VStack {
                VStack {
                    HomeHeaderCard(
                        initials:     user.initials,
                        streak:       viewModel.streak,
                        onProfileTap: { homeCoordinator.push(.profile) },
                        onStreakTap:  { viewModel.recordActivity() },
                        onChatTap:    { homeCoordinator.push(.chat) }
                    )
                    .padding(.top, 60)
                    .padding(.horizontal)

                    MascotGreetingCard(firstName: user.firstName)
                        .padding(.bottom, 100)

                    Spacer()
                }
                .background(
                    Image("dashboard-bg")
                        .resizable()
                        .frame(maxWidth: .infinity)
                )

                if viewModel.activeCourse != nil {
                    VStack {
                        TodayTaskCard(
                            topicName:   activeTopic?.name    ?? "",
                            sectionName: currentSection?.name ?? ""
                        )

                        ActiveLearningCard(
                            courseName:          viewModel.activeCourse?.name           ?? "",
                            courseStageText:     viewModel.activeCourse?.stage.text     ?? "",
                            courseStageProgress: viewModel.activeCourse?.stage.progress ?? 0.0,
                            moduleName:          currentModule?.name                    ?? "",
                            sectionName:         currentSection?.name                   ?? "",
                            onViewPath: {
                                if let course = viewModel.activeCourse {
                                    homeCoordinator.push(.path(course: course))
                                }
                            }
                        )

                        BadgesCard(badges: ["blue-badge", "special-badge", "purple-badge"])
                    }
                    .offset(x: 0, y: -70)
                    .transition(.move(edge: .bottom).combined(with: .opacity).animation(.spring(duration: 1.0)))
                }
            }
        }
        .ignoresSafeArea(edges: .all)
        .onAppear {
            viewModel.getCourse()
            viewModel.getStreak()
        }
    }
}
