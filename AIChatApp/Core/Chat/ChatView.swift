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
    @State private var scrollPosition: String?

    @State private var showAlert: AnyAppAlert?
    @State private var showChatSettings: AnyAppAlert?
    
    @State private var showProfileModal: Bool = false
    
    var avatarId: String = AvatarModel.mock.avatarId
    
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
                    .showCustomAlert(type: .confirmationDialog, alert: $showChatSettings
                    )
            }
        }
        .showCustomAlert(alert: $showAlert)
        // MARK: There is a bug with overlay where nav bar is always the highest level view
        .showModal(for: $showProfileModal) {
            if let avatar {
                profileModal(avatar: avatar)
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
                    ) {
                        onAvatarImagePressed()
                    }
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
    
    private func profileModal(avatar: AvatarModel) -> some View {
        ProfileModalView(
            imageName: avatar.profileImageName,
            title: avatar.name,
            subtitle: avatar.characterOption?.rawValue.capitalized,
            headline: avatar.characterDescription,
            onXMarkPressed: {
                onXMarkPressed()
            }
        )
        .padding(40)
        .transition(.slide)
    }
    
    private func onShowChatSettingsPressed() {
        showChatSettings = AnyAppAlert(
            title: "",
            subtitle: "What would you like to do?",
            buttons: {
                AnyView(
                    Group {
                        Button("Report User / Chat", role: .destructive) {
                            
                        }
                        
                        Button("Delete Chat", role: .destructive) {
                            
                        }
                    }
                )
            }
        )
    }
    
    private func onSendMessagePressed() {
        guard let userId = currentUser?.userId else { return }
        
        do {
            try TextValidationHelper.checkIfTextIsValid(text: textFieldText)
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
        } catch {
            showAlert = AnyAppAlert(
                title: error.localizedDescription
                )
        }
    }
    
    private func onAvatarImagePressed() {
        showProfileModal = true
    }
    
    private func onXMarkPressed() {
        showProfileModal = false
    }
}

#Preview {
    NavigationStack {
        ChatView()
    }
}
