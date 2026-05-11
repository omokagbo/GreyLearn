// FeaturePath/Presentation/CustomViews/BadgeEarnedView.swift
import SwiftUI
import Domain
import DesignSystem

public struct BadgeEarnedView: View {
    private let module: Module

    @State private var decorationScale: CGFloat = 0.05
    @State private var badgeScale: CGFloat = 0.3
    @State private var rotation: Double = -15
    @State private var opacity: Double = 0
    @State private var isFlipped: Bool = false
    @State private var flipDegrees: Double = 0

    public init(module: Module) { self.module = module }

    public var body: some View {
        VStack {
            Button {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                    flipDegrees += 180
                    isFlipped.toggle()
                }
            } label: {
                HStack {
                    Image("flip").resizable().frame(width: 20, height: 20)
                    AppText("Flip badge", style: .callout).foregroundStyle(.black)
                }
                .padding(10)
                .clipShape(Capsule())
                .overlay { Capsule().stroke(Color.gray, lineWidth: 1) }
            }
            .padding(20)

            ZStack {
                Image("badge-decoration")
                    .resizable().scaledToFit()
                    .frame(maxWidth: .infinity).frame(height: 300)
                    .padding(.horizontal)
                    .scaleEffect(decorationScale).opacity(opacity)

                // Front face
                Image("purple-badge")
                    .resizable().scaledToFit().frame(height: 150)
                    .scaleEffect(badgeScale).rotationEffect(.degrees(rotation))
                    .opacity(opacity).opacity(isFlipped ? 0 : 1)
                    .rotation3DEffect(.degrees(flipDegrees), axis: (x: 0, y: 1, z: 0))

                // Back face
                ZStack {
                    Circle().fill(Color.greyMidPurple).frame(height: 150)
                    VStack(spacing: 6) {
                        AppText(module.name, style: .callout)
                            .multilineTextAlignment(.center).foregroundStyle(Color.greyPurple)
                        AppText("✓ Completed", style: .caption).foregroundStyle(Color.greyPurple)
                    }
                    .padding(16)
                }
                .frame(height: 150)
                .scaleEffect(badgeScale).opacity(opacity).opacity(isFlipped ? 1 : 0)
                .rotation3DEffect(.degrees(flipDegrees + 180), axis: (x: 0, y: 1, z: 0))
            }
            .onAppear {
                withAnimation(.spring(response: 0.7, dampingFraction: 0.6)) {
                    decorationScale = 1.0; opacity = 1.0
                }
                withAnimation(.spring(response: 0.5, dampingFraction: 0.45).delay(0.2)) {
                    badgeScale = 1.0; rotation = 0
                }
            }

            VStack(spacing: 20) {
                AppText(module.completionTitle, style: .title).multilineTextAlignment(.center)
                AppText(module.completionCheer, style: .footnote).multilineTextAlignment(.center)
            }
            .padding(.horizontal)

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
