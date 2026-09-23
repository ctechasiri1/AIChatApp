//
//  AvatarManager.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 9/13/26.
//

import SwiftData

import Foundation
import UIKit

@Observable
@MainActor
class AvatarManager {
    private let remote: RemoteAvatarService
    private let local: LocalAvatarPersistence
    
    init(remote: RemoteAvatarService, local: LocalAvatarPersistence = MockAvatarPersistence()) {
        self.remote = remote
        self.local = local
    }
    
    func createAvatar(avatar: AvatarModel, image: UIImage) async throws {
        try await remote.createAvatar(avatar: avatar, image: image)
    }
    
    func getAvatar(id: String) async throws -> AvatarModel {
        try await remote.getAvatar(id: id)
    }
    
    func getFeaturedAvatars() async throws -> [AvatarModel] {
        try await remote.getFeaturedAvatars()
    }
    
    func getPopularAvatars() async throws -> [AvatarModel] {
        try await remote.getPopularAvatars()
    }
    
    func getAvatarsForCategory(category: CharacterOption) async throws -> [AvatarModel] {
        try await remote.getAvatarsForCategory(category: category)
    }
    
    func getAvatarForAuthor(userId: String) async throws -> [AvatarModel] {
        try await remote.getAvatarsForAuthor(userId: userId)
    }
    
    func getRecentAvatars() throws -> [AvatarModel] {
        try local.getRecentAvatars()
    }
    
    func addRecentActivity(avatar: AvatarModel) throws {
        try local.addRecentActivity(avatar: avatar)
    }
}
