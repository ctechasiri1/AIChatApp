//
//  TextValidationHelper.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 7/8/26.
//

import Foundation

struct TextValidationHelper {
    enum TextValidationError: LocalizedError {
        case notEnoughCharacters(min: Int)
        case hasBadWords
        
        var errorDescription: String? {
            switch self {
            case .notEnoughCharacters(let min):
                return "Please add at least \(min) characters."
            case .hasBadWords:
                return "Bad word detected. Please rephrase your message."
            }
        }
    }
    
    static func checkIfTextIsValid(text: String) throws {
        let minimumTextCount: Int = 4
        
        guard text.count >= minimumTextCount else {
            throw TextValidationError.notEnoughCharacters(min: minimumTextCount)
        }
        
        let badWords: [String] = ["shit", "bitch", "ass"]
        
        if badWords.contains(text.lowercased()) {
            throw TextValidationError.hasBadWords
        }
    }
}
