//
//  OpenAIService.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 8/27/26.
//

import OpenAI
import OpenAPIRuntime
import Foundation
import UIKit

struct OpenAIService: AIService {
    
    private let openAI: OpenAI = OpenAI(apiToken: Keys.openAI)
    
    func generateImage(from input: String) async throws -> UIImage {
        let query =  ImagesQuery(
            prompt: input,
            model: .gpt_image_1,
            n: 1,
            quality: .low,
            size: ._1024,
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
}
