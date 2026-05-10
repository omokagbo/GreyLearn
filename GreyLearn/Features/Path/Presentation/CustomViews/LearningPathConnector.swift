//
// LearningPathConnector.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/10/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.
	
import SwiftUI

struct LearningPathConnector: View {
    let modules: [Module]
    let anchors: [Int: Anchor<CGPoint>]
    let lineWidth: CGFloat
    let curveOffset: CGFloat
    let curveEdgeInset: CGFloat
    let curveOvershoot: CGFloat
    let curveLonelyBoost: CGFloat

    var body: some View {
        GeometryReader { proxy in
            let points = resolvePoints(in: proxy)
            let paths = buildPaths(points: points, containerWidth: proxy.size.width)

            paths.solid
                .stroke(
                    Color.greyLightBlue,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round)
                )

            paths.dotted
                .stroke(
                    Color.greyLightBlue,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round, dash: [2, 6])
                )
        }
    }

    private func resolvePoints(in proxy: GeometryProxy) -> [Int: CGPoint] {
        var points: [Int: CGPoint] = [:]
        for module in modules {
            if let anchor = anchors[module.id] {
                points[module.id] = proxy[anchor]
            }
        }
        return points
    }

    private func buildPaths(points: [Int: CGPoint], containerWidth: CGFloat) -> (solid: Path, dotted: Path) {
        var solid = Path()
        var dotted = Path()

        guard modules.count > 1 else { return (solid, dotted) }

        for index in 0..<(modules.count - 1) {
            let current = modules[index]
            let next = modules[index + 1]

            guard let start = points[current.id], let end = points[next.id] else { continue }

            let isSameRow = index / 2 == (index + 1) / 2
            let isDotted = next.completionStatus == .locked

            if isSameRow {
                if isDotted {
                    addHorizontalLine(from: start, to: end, in: &dotted)
                } else {
                    addHorizontalLine(from: start, to: end, in: &solid)
                }
            } else {
                let direction: CGFloat = start.x >= containerWidth / 2 ? 1 : -1
                let isLonelyConnection = modules.count.isMultiple(of: 2) == false
                    && (index + 1) == modules.count - 1
                let outerBaseX = direction > 0 ? (containerWidth - curveEdgeInset) : curveEdgeInset
                let overshoot = curveOvershoot + (isLonelyConnection ? curveLonelyBoost : 0)
                let outerX = direction > 0 ? (outerBaseX + overshoot) : (outerBaseX - overshoot)
                let controlX = direction > 0
                    ? max(start.x + curveOffset, outerX)
                    : min(start.x - curveOffset, outerX)
                let control1 = CGPoint(
                    x: controlX,
                    y: start.y
                )
                let control2 = CGPoint(
                    x: controlX,
                    y: end.y
                )

                if isDotted {
                    addCurve(from: start, to: end, control1: control1, control2: control2, in: &dotted)
                } else {
                    addCurve(from: start, to: end, control1: control1, control2: control2, in: &solid)
                }
            }
        }

        return (solid, dotted)
    }

    private func addLine(from start: CGPoint, to end: CGPoint, in path: inout Path) {
        path.move(to: start)
        path.addLine(to: end)
    }

    private func addHorizontalLine(from start: CGPoint, to end: CGPoint, in path: inout Path) {
        let midY = (start.y + end.y) / 2
        path.move(to: CGPoint(x: start.x, y: midY))
        path.addLine(to: CGPoint(x: end.x, y: midY))
    }

    private func addCurve(from start: CGPoint, to end: CGPoint, control1: CGPoint, control2: CGPoint, in path: inout Path) {
        path.move(to: start)
        path.addCurve(to: end, control1: control1, control2: control2)
    }
}
