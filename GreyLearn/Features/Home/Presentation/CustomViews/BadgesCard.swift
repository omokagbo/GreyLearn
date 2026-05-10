//
// BadgesCard.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/10/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.

import SwiftUI

struct BadgesCard: View {
    let badges: [String]

    var body: some View {
        VStack(alignment: .leading) {
            AppText("Badges", style: .title3)

            HStack(spacing: 20) {
                ForEach(badges, id: \.self) { badge in
                    VStack {
                        Image(badge)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 80)
                            .padding(.bottom, 10)
                        AppText("Genius", style: .caption)
                        AppText("3/3 perfect scores", style: .caption2)
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    BadgesCard(badges: ["blue-badge", "special-badge", "purple-badge"])
}
