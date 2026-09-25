//
//  OpenAIService.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 8/27/26.
//

@preconcurrency import OpenAI
import Foundation
import UIKit

typealias ChatContent = ChatQuery.ChatCompletionMessageParam.ChatCompletionUserMessageParam.Content.VisionContent
typealias ChatText = ChatQuery.ChatCompletionMessageParam.ChatCompletionUserMessageParam.Content.VisionContent.ChatCompletionContentPartTextParam

struct OpenAIService: AIService {
    
    private let openAI: OpenAI = OpenAI(apiToken: Keys.openAI)
    
    func generateImage(from input: String) async throws -> UIImage {
        let query = ImagesQuery(
            prompt: input,
            n: 1,
            quality: .hd,
            responseFormat: .b64_json,
            size: ._512,
            style: .natural,
            user: nil
        )
        
        let result = try await openAI.images(query: query)

        guard let b64Json = result.data.first?.b64Json,
              let data = Data(base64Encoded: b64Json),
              let image = UIImage(data: data) else {
            throw AIManagerError.invalidResponse
        }
        
        return image
    }
    
    func generateText(from chats: [AIChatModel]) async throws -> AIChatModel {
        
        let messages = chats.compactMap({ $0.toOpenAIModel() })
        
        let query = ChatQuery(messages: messages, model: .gpt3_5Turbo)
        
        let result = try await openAI.chats(query: query)
        
        guard
            let chat = result.choices.first?.message,
            let model = AIChatModel(chat: chat)
        else {
            throw AIManagerError.invalidResponse
        }
        
        return model
    }
}

struct AIChatModel {
    let role: AIChatOption
    let message: String
    
    init?(chat: ChatResult.Choice.ChatCompletionMessage) {
        self.role = AIChatOption(role: chat.role)
        
        if let message = chat.content?.string {
            self.message = message
        } else {
            return nil
        }
    }
    
    func toOpenAIModel() -> ChatQuery.ChatCompletionMessageParam? {
        ChatQuery.ChatCompletionMessageParam(
            role: role.openAIRole,
            content: [ChatContent.chatCompletionContentPartTextParam(ChatText(text: message))]
        )
    }
}

enum AIChatOption {
    case user, assistant, tool, system
    
    init(role: ChatQuery.ChatCompletionMessageParam.Role) {
        switch self {
        case .user:
            self = .user
        case .assistant:
            self = .assistant
        case .tool:
            self = .tool
        case .system:
            self = .system
        }
    }
    
    var openAIRole: ChatQuery.ChatCompletionMessageParam.Role {
        switch self {
        case .user:
            return .user
        case .assistant:
            return .assistant
        case .tool:
            return .tool
        case .system:
            return .system
        }
    }
}
