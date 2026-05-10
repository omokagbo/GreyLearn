//
// ActiveLearningCard.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/10/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.

import SwiftUI

struct ActiveLearningCard: View {
    let courseName: String
    let courseStageText: String
    let courseStageProgress: Float
    let moduleName: String
    let sectionName: String
    let onViewPath: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            AppText("Active learning path", style: .title3)

            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 5) {
                    AppText(courseName, style: .body)

                    HStack {
                        AppText(courseStageText, style: .callout)

                        ProgressView(value: Double(courseStageProgress), total: 1.0)
                            .tint(Color.greyPurple)
                            .frame(width: 150)

                        Spacer()
                    }
                }
                .padding(.horizontal)

                HStack(spacing: 10) {
                    Image("purple-badge")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 60)

                    VStack(alignment: .leading, spacing: 5) {
                        AppText(moduleName, style: .bodyBold)
                        AppText(sectionName, style: .callout)
                    }

                    Spacer()
                }
                .padding()
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.greyLightBlue, lineWidth: 1)
                }

                PrimaryButton(title: "View full path →") {
                    onViewPath()
                }
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    ActiveLearningCard(
        courseName: "iOS Development",
        courseStageText: "Intermediate",
        courseStageProgress: 0.5,
        moduleName: "SwiftUI Basics",
        sectionName: "Views & Modifiers",
        onViewPath: {}
    )
}
