//
//  ChatView.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 6/10/26.
//

import SwiftUI

struct ChatView: View {
    private let chats: [ChatModel] = ChatModel.mocks
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(chats) { chat in
                    Text(chat.id)
                }
            }
            .navigationTitle("Chats")
        }
    }
}

#Preview {
    ChatView()
}
