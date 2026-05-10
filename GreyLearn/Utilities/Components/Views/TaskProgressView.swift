//
// TaskProgressView.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/10/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.

import SwiftUI

struct TaskProgressView: View {
    var body: some View {
            ZStack {
                Image("grey-badge")
                    .resizable()
                    .scaledToFit()
                    .padding(10)
                
                Circle()
                    .stroke(Color.greyLightGray, lineWidth: 4)
            }
    }
}

#Preview {
    TaskProgressView()
}
