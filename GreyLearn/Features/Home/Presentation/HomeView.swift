//
// HomeView.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/9/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.

import SwiftUI

struct HomeView: View {
    
    @Environment(HomeCoordinator.self) private var homeCoordinator
    @StateObject private var viewModel: HomeViewModel
    private let user: User
    
    private var currentModule: Module? {
        viewModel.activeCourse?.modules.first(where: { $0.completionStatus == .inProgress})
    }
    private var currentSection: Section? {
        currentModule?.sections.first(where: { !$0.isCompleted })
    }
    private var activeTopic: Topic? {
        currentSection?.topics.first(where: { !$0.isCompleted })
    }
    
    init(user: User, dependencies: HomeDependencies = .mock) {
        self.user = user
        _viewModel = StateObject(wrappedValue: HomeViewModel(dependencies: dependencies))
    }
    
    var body: some View {
        @Bindable var homeCoordinator = homeCoordinator

        NavigationStack(path: $homeCoordinator.path) {
            ScrollView {
                VStack {
                    VStack {
                        HomeHeaderCard(
                                initials: user.initials,
                                streak: viewModel.streak,
                                onProfileTap: { homeCoordinator.push(.profile) },
                                onStreakTap: { viewModel.recordActivity() },
                                onChatTap: { homeCoordinator.push(.chat) }
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
                    
                    if let _ = viewModel.activeCourse {
                        VStack {
                            TodayTaskCard(
                                topicName: activeTopic?.name ?? "",
                                sectionName: currentSection?.name ?? ""
                            )

                            ActiveLearningCard(
                                courseName: viewModel.activeCourse?.name ?? "",
                                courseStageText: viewModel.activeCourse?.stage.text ?? "",
                                courseStageProgress: viewModel.activeCourse?.stage.progress ?? 0.0,
                                moduleName: currentModule?.name ?? "",
                                sectionName: currentSection?.name ?? "",
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
            .navigationDestination(for: HomeRoute.self) { route in
                HomeRouteView(route: route)
                    .environment(homeCoordinator)
            }
        }
    }
    
    
}

#Preview {
    HomeView(user: User.user, dependencies: HomeDependencies(
        courseRepository: MockCourseRepository(delayNanoseconds: 0),
        localRepository: LocalRepository()
    ))
}
