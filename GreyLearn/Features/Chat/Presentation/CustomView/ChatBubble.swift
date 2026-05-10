//
// ChatBubble.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/10/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.
	
import SwiftUI

struct ChatBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.isFromUser { Spacer(minLength: 60) }

            Text(message.text)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(message.isFromUser ? Color.greyPurple : Color.greyMidPurple)
                .foregroundStyle(message.isFromUser ? Color.white : Color.primary)
                .clipShape(RoundedRectangle(cornerRadius: 18))

            if !message.isFromUser { Spacer(minLength: 60) }
        }
    }
}
