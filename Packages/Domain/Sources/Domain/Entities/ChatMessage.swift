// Domain/Entities/ChatMessage.swift
import Foundation

public struct ChatMessage: Identifiable {
    public let id = UUID()
    public let text: String
    public let isFromUser: Bool

    public init(text: String, isFromUser: Bool) {
        self.text = text
        self.isFromUser = isFromUser
    }

    public static let dummies: [ChatMessage] = [
        ChatMessage(text: "Hey! 👋 How can I help you today?", isFromUser: false),
        ChatMessage(text: "I'm having trouble understanding the SwiftUI module.", isFromUser: true),
        ChatMessage(text: "No worries! Which part is giving you trouble — state management or layout?", isFromUser: false),
    ]
}
