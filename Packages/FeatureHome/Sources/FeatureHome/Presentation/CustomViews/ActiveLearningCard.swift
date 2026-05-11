// FeatureHome/Presentation/CustomViews/ActiveLearningCard.swift
import SwiftUI
import DesignSystem

public struct ActiveLearningCard: View {
    let courseName: String
    let courseStageText: String
    let courseStageProgress: Float
    let moduleName: String
    let sectionName: String
    let onViewPath: () -> Void

    public init(
        courseName: String,
        courseStageText: String,
        courseStageProgress: Float,
        moduleName: String,
        sectionName: String,
        onViewPath: @escaping () -> Void
    ) {
        self.courseName          = courseName
        self.courseStageText     = courseStageText
        self.courseStageProgress = courseStageProgress
        self.moduleName          = moduleName
        self.sectionName         = sectionName
        self.onViewPath          = onViewPath
    }

    public var body: some View {
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

                PrimaryButton(title: "View full path →", action: onViewPath)
            }
            .padding()
        }
        .padding()
    }
}
