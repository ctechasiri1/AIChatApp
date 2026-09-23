//
//  ChatsView.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 6/10/26.
//

import SwiftUI

struct ChatsView: View {
    @Environment(AvatarManager.self) private var avatarManager
    
    @State var path: [NavigationPathOption] = []
    
    @State private var chats: [ChatModel] = []
    @State private var recentAvatars: [AvatarModel] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                if !recentAvatars.isEmpty {
                    recentsSection
                }
                
                chatsSection
            }
            .navigationTitle("Chats")
            .navigationDestinationForCoreModule(path: $path)
            .onAppear {
                loadRecentAvatars()
            }
        }
    }
    
    private func loadRecentAvatars() {
        do {
            recentAvatars = try avatarManager.getRecentAvatars()
        } catch {
            print("Failed to load recents.")
        }
    }
    
    private var chatsSection: some View {
        Section {
            if chats.isEmpty {
                Text("Your chats will appear here.")
                    .foregroundStyle(.secondary)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(40)
                    .removeListRowFormatting()
            } else {
                ForEach(chats) { chat in
                    ChatRowCellViewBuilder(
                        currentUserId: nil, // add later
                        chat: chat,
                        getAvatar: {
                            try? await Task.sleep(for: .seconds(1))
                            return AvatarModel.mocks.randomElement()!
                        },
                        getLastMessage: {
                            try? await Task.sleep(for: .seconds(1))
                            return ChatMessageModel.mocks.randomElement()!
                        }
                    )
                    .anyButton(.highlight, action: {
                        onChatPressed(chat: chat)
                    })
                    .removeListRowFormatting()
                }
            }
        } header: {
            Text("CHATS")
        }
    }
    
    private var recentsSection: some View {
        Section {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 8) {
                    ForEach(recentAvatars, id: \.self) { avatar in
                        VStack(spacing: 8) {
                            if let imageName = avatar.profileImageName {
                                ImageLoaderView(urlString: imageName)
                                    .aspectRatio(1, contentMode: .fit)
                                    .clipShape(Circle())
                            }
                            
                            Text(avatar.name ?? "")
                        }
                        .anyButton {
                            onAvatarPressed(avatar: avatar)
                        }
                    }
                }
                .padding(.top, 12)
            }
            .frame(height: 120)
            .removeListRowFormatting()
        } header: {
            Text("RECENTS")
        }
    }
    
    private func onChatPressed(chat: ChatModel) {
        path.append(.chat(avatarId: chat.avatarId))
    }
    
    private func onAvatarPressed(avatar: AvatarModel) {
        path.append(.chat(avatarId: avatar.avatarId))
    }
}

#Preview {
    ChatsView()
        .environment(AvatarManager(remote: MockAvatarService()))
}
