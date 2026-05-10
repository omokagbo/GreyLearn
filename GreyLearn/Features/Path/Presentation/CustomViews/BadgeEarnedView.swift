//
// BadgeEarnedView.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/10/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.

import SwiftUI

struct BadgeEarnedView: View {
    private let module: Module
    
    init(module: Module) {
        self.module = module
    }
    var body: some View {
        VStack {
            Button {
                //flip badge
            } label: {
                HStack {
                    Image("flip")
                        .resizable()
                        .frame(width: 20, height: 20)
                    AppText("Flip badge", style: .callout)
                        .foregroundStyle(.black)
                }
                .padding(10)
                .clipShape(Capsule())
                .overlay {
                    Capsule()
                        .stroke(Color.gray, lineWidth: 1)
                }
            }
            .padding(20)
            
            ZStack {
                Image("badge-decoration")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(height: 300)
                    .padding(.horizontal)
                
                Image("purple-badge")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .tint(.blue)
            }
            
            VStack(spacing: 20) {
                AppText(module.completionTitle, style: .title)
                    .multilineTextAlignment(.center)
                
                AppText(module.completionCheer, style: .footnote)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal)
            
            //keeping it simple. A UIActivityViewController using UIViewControllerRepresentable would be better especially for apps targeting under iOS16
            ShareLink(item: module.shareMessage, preview: SharePreview(module.completionTitle)) {
                AppText("Share your achievement", style: .button)
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white, .gray)
                    .background(Color.greyPurple)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .contentShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(.top, 30)

        }
        .padding()
        .padding(.bottom, 20)
    }
}

#Preview {
    BadgeEarnedView(module: Course.mockCourse.modules.first!)
}
