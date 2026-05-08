//
//  LaunchScreenView.swift
//  GreyLearn
//
//  Created by Emmanuel Omokagbo on 5/8/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.

import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        ZStack {
            Color("grey-purple")
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Image("Mascot")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)

                Text("GreyLearn")
                    .font(.custom("Aeonik-Bold", size: 34))
                    .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    LaunchScreenView()
}
