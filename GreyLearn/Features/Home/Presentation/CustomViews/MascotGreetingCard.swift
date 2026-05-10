//
// MascotGreetingCard.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/10/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.

import SwiftUI

struct MascotGreetingCard: View {
    let firstName: String

    var body: some View {
        VStack(spacing: 10) {
            Image("Mascot")
                .resizable()
                .scaledToFit()
                .frame(height: 200)

            AppText(Date().greeting(withName: firstName), style: .title)

            AppText("You're closer than you think 💪🏾", style: .subheadline)
        }
    }
}

#Preview {
    MascotGreetingCard(firstName: "Emmanuel")
}
