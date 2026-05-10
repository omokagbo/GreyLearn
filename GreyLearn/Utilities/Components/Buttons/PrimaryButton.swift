//
// PrimaryButton.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/10/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .padding(.vertical, 15)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white, .gray)
                .background(Color.greyPurple)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .contentShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    PrimaryButton(title: "Share your achievement") {
        print("test button")
    }
}
