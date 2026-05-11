// DesignSystem/Components/AppTextStyle.swift
import SwiftUI

public enum AppTextStyle {
    case title, title2, title3
    case headline, subheadline
    case body, bodyBold
    case callout
    case footnote
    case caption, captionBold, caption2
    case button

    public var font: Font {
        switch self {
        case .title:       return FontHelper.aeonik(.bold,    size: AppTypography.Size.title)
        case .title2:      return FontHelper.aeonik(.bold,    size: AppTypography.Size.title2)
        case .title3:      return FontHelper.aeonik(.bold,    size: AppTypography.Size.title3)
        case .headline:    return FontHelper.aeonik(.medium,  size: AppTypography.Size.headline)
        case .subheadline: return FontHelper.aeonik(.regular, size: AppTypography.Size.subheadline)
        case .body:        return FontHelper.aeonik(.regular, size: AppTypography.Size.body)
        case .bodyBold:    return FontHelper.aeonik(.bold,    size: AppTypography.Size.body)
        case .callout:     return FontHelper.aeonik(.regular, size: AppTypography.Size.callout)
        case .footnote:    return FontHelper.aeonik(.regular, size: AppTypography.Size.footnote)
        case .caption:     return FontHelper.aeonik(.regular, size: AppTypography.Size.caption)
        case .captionBold: return FontHelper.aeonik(.bold,    size: AppTypography.Size.caption)
        case .caption2:    return FontHelper.aeonik(.regular, size: AppTypography.Size.caption2)
        case .button:      return FontHelper.aeonik(.medium,  size: AppTypography.Size.button)
        }
    }
}

/// A pre-styled text view that uses the GreyLearn design system typography.
public struct AppText: View {
    let text: String
    let style: AppTextStyle

    public init(_ text: String, style: AppTextStyle) {
        self.text  = text
        self.style = style
    }

    public var body: some View {
        Text(text).font(style.font)
    }
}
