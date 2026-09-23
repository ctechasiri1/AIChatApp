//
//  LocalAvatarPersistence.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 9/22/26.
//

import Foundation

@MainActor
protocol LocalAvatarPersistence {
    func addRecentActivity(avatar: AvatarModel) throws
    func getRecentAvatars() throws -> [AvatarModel]
}
