//
//  UserModel.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 7/1/26.
//

import Foundation
import SwiftUI

struct UserModel {
    
    let userId: String
    let dateCreated: Date?
    let didCompleteOnboarding: Bool?
    let profileColorHex: String?
    
    init(
        userId: String,
        dateCreated: Date? = nil,
        didCompleteOnboarding: Bool? = nil,
        profileColorHex: String? = nil
    ) {
        self.userId = userId
        self.dateCreated = dateCreated
        self.didCompleteOnboarding = didCompleteOnboarding
        self.profileColorHex = profileColorHex
    }
    
    var profileColorCalculated: Color {
        guard let profileColorHex else { return .accent }
        return Color(hex: profileColorHex)
    }
    
    static var mock: Self {
        mocks[0]
    }
    
    static var mocks: [Self] {
        return [
            UserModel(
                userId: "user_001",
                dateCreated: Date(),
                didCompleteOnboarding: true,
                profileColorHex: "#FF5733"
            ),
            UserModel(
                userId: "user_002",
                dateCreated: Date().addingTimeInterval(-86_400 * 7),
                didCompleteOnboarding: false,
                profileColorHex: "#3498DB"
            ),
            UserModel(
                userId: "user_003",
                dateCreated: Date().addingTimeInterval(-86_400 * 30),
                didCompleteOnboarding: nil,
                profileColorHex: nil
            ),
            UserModel(
                userId: "user_004",
                dateCreated: nil,
                didCompleteOnboarding: true,
                profileColorHex: "#2ECC71"
            )
        ]
    }
}
