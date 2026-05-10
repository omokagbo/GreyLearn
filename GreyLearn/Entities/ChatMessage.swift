//
// ChatMessage.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/10/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.
	
import SwiftUI

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isFromUser: Bool

    static let dummies: [ChatMessage] = [
        ChatMessage(text: "Hey! 👋 How can I help you today?", isFromUser: false),
        ChatMessage(text: "I'm having trouble understanding the SwiftUI module.", isFromUser: true),
        ChatMessage(text: "No worries! Which part is giving you trouble — state management or layout?", isFromUser: false),
    ]
}
