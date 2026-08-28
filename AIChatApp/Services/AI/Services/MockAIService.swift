//
//  MockAIService.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 8/27/26.
//

import Foundation
import UIKit

struct MockAIService: AIService {
    func generateImage(from input: String) async throws -> UIImage {
        try await Task.sleep(for: .seconds(1))
        return UIImage(systemName: "star.fill")!
    }
}
