//
// String+Extension.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/10/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.
	
import Foundation

extension String {
    var firstLetter: String {
        return self.first.map { String($0).uppercased() } ?? ""
    }
}
