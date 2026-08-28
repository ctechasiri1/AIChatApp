//
//  AIService.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 8/27/26.
//

import Foundation
import UIKit

enum AIManagerError: LocalizedError {
    case invalidResponse
}

protocol AIService {
    func generateImage(from input: String) async throws -> UIImage
}
