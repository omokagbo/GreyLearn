// FeatureLaunch/LaunchScreenView.swift
import SwiftUI
import DesignSystem

public struct LaunchScreenView: View {
    public init() {}

    public var body: some View {
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
