//
// FontHelper.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/10/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.
	
import SwiftUI

struct FontHelper {
    static func aeonik(_ font: AeonikFont, size: CGFloat) -> Font {
        .custom(font.rawValue, size: size)
    }
}

