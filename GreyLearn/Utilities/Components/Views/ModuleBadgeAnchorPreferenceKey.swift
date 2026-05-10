//
// ModuleBadgeAnchorPreferenceKey.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/10/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.

import SwiftUI

struct ModuleBadgeAnchorPreferenceKey: PreferenceKey {
    static var defaultValue: [Int: Anchor<CGPoint>] = [:]

    static func reduce(value: inout [Int: Anchor<CGPoint>], nextValue: () -> [Int: Anchor<CGPoint>]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

struct CourseProgressView: View {
    private let module: Module
    private var activeSection: Section? {
        module.sections.first(where: { section in
            section.isCompleted == false
        })
    }
    private var isCompleted: Bool {
        module.completionStatus == .completed
    }
    private var isLocked: Bool {
        module.completionStatus == .locked
    }
    
    init(module: Module) {
        self.module = module
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Image(module.badgeIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
//                    .padding(isCompleted ? 0 : 20)
                
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

#Preview {
    CourseProgressView(module: Course.mockCourse.modules.first!)
}
