// FeaturePath/Presentation/PathView.swift
import SwiftUI
import AppCoordination
import Domain
import DesignSystem
import Core

public struct PathView: View {
    @Environment(PathCoordinator.self) private var coordinator
    let course: Course

    private let rowShift:                CGFloat = 16
    private let rowSpacing:              CGFloat = 36
    private let horizontalPadding:       CGFloat = 30
    private let itemStaggerY:            CGFloat = 18
    private let connectorLineWidth:      CGFloat = 2
    private let connectorCurveOffset:    CGFloat = 36
    private let connectorCurveEdgeInset: CGFloat = 12
    private let connectorCurveOvershoot: CGFloat = 18
    private let connectorCurveLonelyBoost: CGFloat = 32

    public init(course: Course) { self.course = course }

    public var body: some View {
        @Bindable var coordinator = coordinator

        ScrollView {
            VStack(alignment: .leading) {
                AppText(course.stage.text, style: .caption)
                AppText("\(course.name) path", style: .title)
                    .multilineTextAlignment(.leading)

                VStack(spacing: rowSpacing) {
                    ForEach(Array(course.modules.chunked(into: 2).enumerated()), id: \.offset) { rowIndex, row in
                        rowView(rowIndex: rowIndex, row: row)
                    }
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.top, 12)
                .backgroundPreferenceValue(ModuleBadgeAnchorPreferenceKey.self) { anchors in
                    LearningPathConnector(
                        modules: course.modules,
                        anchors: anchors,
                        lineWidth: connectorLineWidth,
                        curveOffset: connectorCurveOffset,
                        curveEdgeInset: connectorCurveEdgeInset,
                        curveOvershoot: connectorCurveOvershoot,
                        curveLonelyBoost: connectorCurveLonelyBoost
                    )
                    .allowsHitTesting(false)
                }
            }
            .padding()
        }
        .customBackButton(onPop: { coordinator.pop() })
        .sheet(item: $coordinator.presentedRoute) { route in
            switch route {
            case .badgeDetails(let module):
                BadgeEarnedView(module: module)
                    .presentationDetents([.fraction(route.sheetHeight)])
                    .presentationDragIndicator(.visible)
            }
        }
    }

    @ViewBuilder
    private func rowView(rowIndex: Int, row: [Module]) -> some View {
        let shiftX    = (rowIndex % 2 == 0) ? rowShift : -rowShift
        let isOddRow  = rowIndex % 2 == 1

        let leftModule: Module? = {
            if row.isEmpty   { return nil }
            if row.count == 1 { return row[0] }
            return isOddRow ? row[1] : row[0]
        }()

        let rightModule: Module? = {
            guard row.count == 2 else { return nil }
            return isOddRow ? row[0] : row[1]
        }()

        let shouldStagger = rowIndex != 0
        let leftY:  CGFloat = shouldStagger ? (isOddRow ? itemStaggerY : 0) : 0
        let rightY: CGFloat = shouldStagger ? (isOddRow ? 0 : itemStaggerY) : 0

        HStack(alignment: .top) {
            if let rightModule, let left = leftModule {
                CourseProgressView(module: left)
                    .offset(y: leftY)
                    .onTapGesture {
                        if left.completionStatus == .completed {
                            coordinator.push(.badgeDetails(module: left))
                        }
                    }

                Spacer(minLength: 0)

                CourseProgressView(module: rightModule)
                    .offset(y: rightY)
                    .onTapGesture {
                        if rightModule.completionStatus == .completed {
                            coordinator.push(.badgeDetails(module: rightModule))
                        }
                    }
            } else if let only = leftModule {
                Spacer(minLength: 0)
                CourseProgressView(module: only)
                    .onTapGesture {
                        if only.completionStatus == .completed {
                            coordinator.push(.badgeDetails(module: only))
                        }
                    }
                Spacer(minLength: 0)
            }
        }
        .offset(x: shouldStagger ? shiftX : 0)
    }
}
