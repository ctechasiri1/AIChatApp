//
//  AIManager.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 8/27/26.
//

import Observation
import Foundation
import UIKit

@Observable
class AIManager {
    private let service: AIService
    
    init(service: AIService) {
        self.service = service
    }
    
    func generateImage(from input: String) async throws -> UIImage {
        try await service.generateImage(from: input)
    }
}
