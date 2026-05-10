//
// TodayTaskView.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/10/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.

import SwiftUI

struct TodayTaskCard: View {
    let topicName: String
    let sectionName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                AppText("For today", style: .title2)
                Spacer()
            }

            HStack {
                TaskProgressView()
                    .frame(width: 60, height: 60)
                    .padding(.trailing, 10)

                VStack(alignment: .leading, spacing: 10) {
                    AppText(topicName, style: .callout)

                    HStack {
                        Image(systemName: "calendar")
                        AppText(sectionName, style: .caption)
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
            }
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding()
        .shadow(radius: 0.5)
    }
}

#Preview {
    TodayTaskCard(topicName: "Introduction to Swift", sectionName: "Section 1")
}
