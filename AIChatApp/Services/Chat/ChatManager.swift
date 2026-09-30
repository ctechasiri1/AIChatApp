//
//  ChatManager.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 9/29/26.
//

import FirebaseFirestore
import Foundation
import SwiftfulFirestore

protocol ChatService: Sendable {
    func createNewChat(chat: ChatModel) async throws
}

struct FireBaseChatService: ChatService {
    var collection: CollectionReference {
        Firestore.firestore().collection("chats")
    }
    
    func createNewChat(chat: ChatModel) async throws {
        try collection.document(chat.id).setData(from: chat, merge: true)
    }
}

struct MockChatService: ChatService {
    func createNewChat(chat: ChatModel) async throws {
        try await Task.sleep(for: .seconds(2))
    }
}



@MainActor
@Observable
class ChatManager {
    var service: ChatService
    
    init(service: ChatService) {
        self.service = service
    }
    
    func createNewChat(chat: ChatModel) async throws {
        try await service.createNewChat(chat: chat)
    }
}
