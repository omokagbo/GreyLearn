// FeatureChat/Presentation/ChatView.swift
import SwiftUI
import AppCoordination
import Domain
import DesignSystem

public struct ChatView: View {
    @Environment(ChatCoordinator.self) private var coordinator

    @State private var messageText: String = ""
    @State private var messages: [ChatMessage] = ChatMessage.dummies

    public init() {}

    public var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(messages) { message in
                            ChatBubble(message: message).id(message.id)
                        }
                    }
                    .padding()
                }
                .onChange(of: messages.count) {
                    withAnimation { proxy.scrollTo(messages.last?.id, anchor: .bottom) }
                }
            }

            Divider()

            HStack(spacing: 12) {
                TextField("Type a message…", text: $messageText, axis: .vertical)
                    .lineLimit(1...4)
                    .padding(12)
                    .background(Color.greyLightGray)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                Button { sendMessage() } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .frame(width: 36, height: 36)
                        .foregroundStyle(
                            messageText.trimmingCharacters(in: .whitespaces).isEmpty
                                ? Color.gray : Color.greyPurple
                        )
                }
                .disabled(messageText.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color.white)
        }
        .navigationTitle("Chat")
        .navigationBarTitleDisplayMode(.inline)
        .customBackButton(onPop: { coordinator.pop() })
    }

    private func sendMessage() {
        let trimmed = messageText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        messages.append(ChatMessage(text: trimmed, isFromUser: true))
        messageText = ""
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            messages.append(ChatMessage(
                text: "Thanks for your message! A tutor will get back to you shortly. 👋",
                isFromUser: false
            ))
        }
    }
}
