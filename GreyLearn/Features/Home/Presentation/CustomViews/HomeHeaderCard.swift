//
// HomeHeaderView.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/10/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.

import SwiftUI

struct HomeHeaderCard: View {
    let initials: String
    let streak: String

    var body: some View {
        HStack {
            AppText(initials, style: .headline)
                .padding(10)
                .background(Color.greyMidPurple)
                .clipShape(Circle())
            Spacer()
            AppText(streak, style: .headline)
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .clipShape(Capsule())
                .overlay {
                    Capsule()
                        .stroke(Color.greyLightPurple, lineWidth: 1)
                }
            Spacer()
            Image("messaging")
                .resizable()
                .scaledToFit()
                .frame(width: 22.22)
                .padding(10)
                .background(Color.greyMidPurple)
                .clipShape(Circle())
        }
    }
}

#Preview {
    HomeHeaderCard(initials: "EO", streak: "🔥 5")
}
