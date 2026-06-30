//
//  ChatRowCellViewBuilder.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 6/29/26.
//

import SwiftUI

struct ChatRowCellViewBuilder: View {
    
    var currentUserId: String? = ""
    var chat: ChatModel = .mock
    var getAvatar: () async -> AvatarModel?
    var getLastMessage: () async -> ChatMessageModel?
    
    @State private var avatar: AvatarModel?
    @State private var lastChatMessage: ChatMessageModel?
    
    @State private var didLoadAvatar: Bool = false
    @State private var didLoadChatMessage: Bool = false
    
    private var hasNewChat: Bool {
        guard let lastChatMessage, let currentUserId else { return false }
        
        return lastChatMessage.hasBeenSeenBy(userId: currentUserId)
    }
    
    private var isLoading: Bool {
        if didLoadAvatar && didLoadChatMessage {
            return false
        } else {
            return true
        }
    }
    
    private var subheadline: String? {
        if isLoading {
            return "xxxx xxxx xxxx"
        }
        
        if avatar == nil && lastChatMessage == nil {
            return "There was an error loading the chat."
        }
        
        return lastChatMessage?.content
    }
    
    var body: some View {
        ChatRowCellView(
            imageName: avatar?.profileImageName,
            headline: isLoading ? "xxxx xxxx" : avatar?.name,
            subheadline: subheadline,
            hasNewChat: isLoading ? false : hasNewChat
        )
        .task {
            avatar = await getAvatar()
            didLoadAvatar = true
        }
        .task {
            lastChatMessage = await getLastMessage()
            didLoadChatMessage = true
        }
        .redacted(reason: isLoading ? .placeholder : [])
    }
}

#Preview {
    VStack {
        ChatRowCellViewBuilder(getAvatar: {
            try? await Task.sleep(for: .seconds(5))
            return .mock
        }, getLastMessage: {
            try? await Task.sleep(for: .seconds(5))
            return .mock
        })
        
        ChatRowCellViewBuilder(getAvatar: {
            .mock
        }, getLastMessage: {
            .mock
        })
        
        ChatRowCellViewBuilder(getAvatar: {
            nil
        }, getLastMessage: {
            nil
        })
    }
}
