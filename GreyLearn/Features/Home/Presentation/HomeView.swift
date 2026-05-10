//
// HomeView.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/9/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.
    

import SwiftUI

struct HomeView: View {
    
    @Environment(AppCoordinator.self) private var appCoordinator
    @StateObject private var viewModel: DashboardViewModel
    private let student: User
    
    private var currentModule: Module? {
        viewModel.activeCourse?.modules.first(where: { $0.completionStatus == .inProgress})
    }
    private var currentSection: Section? {
        currentModule?.sections.first(where: { !$0.isCompleted })
    }
    private var activeTopic: Topic? {
        currentSection?.topics.first(where: { !$0.isCompleted })
    }
    
    init(user: User, repository: CourseRepository = MockCourseRepository()) {
        self.student = user
        _viewModel = StateObject(wrappedValue: DashboardViewModel(repository: repository, localRepository: LocalRepository()))
    }
    
    var body: some View {
        @Bindable var appCoordinator = appCoordinator
        
        NavigationStack(path: $appCoordinator.path) {
            ScrollView {
                VStack {
                    VStack {
                        HomeHeaderCard(
                                initials: student.initials,
                                streak: viewModel.streak,
                                onProfileTap: { appCoordinator.homeCoordinator.push(.profile) },
                                onChatTap: { appCoordinator.homeCoordinator.push(.chat) }
                            )
                            .padding(.top, 60)
                            .padding(.horizontal)
                        
                        MascotGreetingCard(firstName: student.firstName)
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
                                        appCoordinator.homeCoordinator.push(.path(course: course))
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
            .navigationDestination(for: AppRoute.self) { route in
                AppRouteView(route: route)
                    .environment(appCoordinator)
            }
        }
    }
    
    
}

#Preview {
    HomeView(user: User.user, repository: MockCourseRepository(delayNanoseconds: 0))
}
