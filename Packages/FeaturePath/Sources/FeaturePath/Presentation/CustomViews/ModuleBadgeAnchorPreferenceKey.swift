// FeaturePath/Presentation/CustomViews/ModuleBadgeAnchorPreferenceKey.swift
import SwiftUI
import Domain
import DesignSystem

public struct ModuleBadgeAnchorPreferenceKey: PreferenceKey {
    public static var defaultValue: [Int: Anchor<CGPoint>] = [:]

    public static func reduce(value: inout [Int: Anchor<CGPoint>], nextValue: () -> [Int: Anchor<CGPoint>]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

/// Displays a single module's badge and status ring on the learning path.
public struct CourseProgressView: View {
    private let module: Module
    private var activeSection: Domain.Section? {
        module.sections.first(where: { !$0.isCompleted })
    }
    private var isCompleted: Bool { module.completionStatus == .completed }
    private var isLocked: Bool    { module.completionStatus == .locked }

    public init(module: Module) { self.module = module }

    public var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Image(module.badgeIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)

                if !isCompleted {
                    Group {
                        Circle()
                            .stroke(isLocked ? Color.greyLightGray : Color.greyLightBlue, lineWidth: 7)

                        if !isLocked {
                            Circle()
                                .trim(from: 0, to: 0.2)
                                .stroke(Color.greyBlue, lineWidth: 7)
                                .rotationEffect(Angle(degrees: -90))
                        }
                    }
                }
            }
            .background(.white)
            .frame(maxWidth: 100, maxHeight: 100)
            .anchorPreference(key: ModuleBadgeAnchorPreferenceKey.self, value: .center) { [module.id: $0] }
            .padding(.vertical, isCompleted ? 0 : 10)

            VStack(spacing: 5) {
                AppText(module.name, style: .captionBold)
                    .multilineTextAlignment(.center)

                if module.completionStatus == .inProgress {
                    AppText(activeSection?.name ?? "", style: .caption2)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: 120)
        }
    }
}
