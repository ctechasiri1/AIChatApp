//
//  MockAvatarPersistence.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 9/22/26.
//

import Foundation

@MainActor
struct MockAvatarPersistence: LocalAvatarPersistence {
    func addRecentActivity(avatar: AvatarModel) throws { }
    
    func getRecentAvatars() throws -> [AvatarModel] {
        AvatarModel.mocks.shuffled()
    }
}
