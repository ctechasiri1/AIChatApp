//
//  ChatView.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 7/6/26.
//

import SwiftUI

struct ChatView: View {
    
    @State private var chatMessages: [ChatMessageModel] = ChatMessageModel.mocks
    @State private var avatar: AvatarModel? = .mock
    @State private var currentUser: UserModel? = .mock
    
    @State private var textFieldText: String = ""
    @State private var showChatSettings: Bool = false
    @State private var scrollPosition: String?
    
    var body: some View {
        VStack(spacing: 0) {
            scrollViewSection
            textFieldSection
        }
        .navigationTitle(avatar?.name ?? "Chat")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Image(systemName: "ellipsis")
                    .padding(8)
                    .anyButton {
                        onShowChatSettingsPressed()
                    }
                    .confirmationDialog("", isPresented: $showChatSettings) {
                        Button("Report User / Chat", role: .destructive) {
                            
                        }
                        
                        Button("Delete Chat", role: .destructive) {
                            
                        }
                    } message: {
                        Text("What would you like to do?")
                    }
            }
        }
    }
    
    private var scrollViewSection: some View {
        ScrollView {
            LazyVStack {
                ForEach(chatMessages) { message in
                    let isCurrentUser = message.authorId == currentUser?.userId
                    ChatBubbleViewBuilder(
                        message: message,
                        isCurrentUser: isCurrentUser,
                        imageName: isCurrentUser ? nil : avatar?.profileImageName
                    )
                    .id(message.id)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(8)
        }
        .defaultScrollAnchor(.bottom)
        .scrollPosition(id: $scrollPosition, anchor: .center)
        .animation(.default, value: chatMessages.count)
        .animation(.default, value: scrollPosition)
    }
    
    private var textFieldSection: some View {
        TextField("Say something...", text: $textFieldText)
            .keyboardType(.alphabet)
            .autocorrectionDisabled()
            .padding(.trailing, 40)
            .padding(12)
            .overlay(alignment: .trailing, content: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(.accent)
                    .padding(.trailing, 4)
                    .anyButton {
                        onSendMessagePressed()
                    }
            })
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 100)
                        .fill(Color(uiColor: .systemBackground))
                    
                    RoundedRectangle(cornerRadius: 100)
                        .stroke(.secondary.opacity(0.3), lineWidth: 1)
                }
            )
            .padding()
            .background(Color(uiColor: .systemGray6))
    }
    
    private func onShowChatSettingsPressed() {
        showChatSettings = true
    }
    
    private func onSendMessagePressed() {
        guard let userId = currentUser?.userId else { return }
        let content = textFieldText
        let message = ChatMessageModel(
            id: UUID().uuidString,
            chatId: UUID().uuidString,
            authorId: userId,
            content: content,
            seenByIds: nil,
            dateCreated: .now
        )
        chatMessages.append(message)
        scrollPosition = message.id
        textFieldText = ""
    }
}

#Preview {
    NavigationStack {
        ChatView()
    }
}
