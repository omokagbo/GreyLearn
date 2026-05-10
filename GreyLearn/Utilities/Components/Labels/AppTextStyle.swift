//
// AppTextStyle.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/10/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.

import SwiftUI

enum AppTextStyle {
    case title
    case title2
    case title3
    case headline
    case subheadline
    case body
    case bodyBold
    case callout
    case footnote
    case caption
    case captionBold
    case caption2
    case button

    var font: Font {
        switch self {
        case .title:
            return FontHelper.aeonik(.bold, size: AppTypography.Size.title)
        case .title2:
            return FontHelper.aeonik(.bold, size: AppTypography.Size.title2)
        case .title3:
            return FontHelper.aeonik(.bold, size: AppTypography.Size.title3)
        case .headline:
            return FontHelper.aeonik(.medium, size: AppTypography.Size.headline)
        case .subheadline:
            return FontHelper.aeonik(.regular, size: AppTypography.Size.subheadline)
        case .body:
            return FontHelper.aeonik(.regular, size: AppTypography.Size.body)
        case .bodyBold:
            return FontHelper.aeonik(.bold, size: AppTypography.Size.body)
        case .callout:
            return FontHelper.aeonik(.regular, size: AppTypography.Size.callout)
        case .footnote:
            return FontHelper.aeonik(.regular, size: AppTypography.Size.footnote)
        case .caption:
            return FontHelper.aeonik(.regular, size: AppTypography.Size.caption)
        case .captionBold:
            return FontHelper.aeonik(.bold, size: AppTypography.Size.caption)
        case .caption2:
            return FontHelper.aeonik(.regular, size: AppTypography.Size.caption2)
        case .button:
            return FontHelper.aeonik(.medium, size: AppTypography.Size.button)
        }
    }
}

struct AppText: View {
    let text: String
    let style: AppTextStyle

    init(_ text: String, style: AppTextStyle) {
        self.text = text
        self.style = style
    }

    var body: some View {
        Text(text)
            .font(style.font)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 8) {
        AppText("Fullstack mobile engineer path", style: .title)
        AppText("Stage 3 of 11", style: .subheadline)
        AppText("Build mobile UI screens and learn layout fundamentals.", style: .body)
        AppText("Component lifecycle", style: .caption)
        AppText("Share your achievement", style: .button)
    }
    .padding()
}
