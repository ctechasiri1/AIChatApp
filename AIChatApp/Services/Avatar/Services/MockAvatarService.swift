//
//  MockAvatarService.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 9/19/26.
//

import Foundation
import UIKit

struct MockAvatarService: RemoteAvatarService {
    
    let avatars: [AvatarModel]
    let delay: Double
    let showError: Bool
    
    init(avatars: [AvatarModel] = AvatarModel.mocks, delay: Double = 0, showError: Bool = false) {
        self.avatars = avatars
        self.delay = delay
        self.showError = showError
    }
    
    private func tryShowError() throws {
        if showError {
            throw URLError(.unknown)
        }
    }
    
    func createAvatar(avatar: AvatarModel, image: UIImage) async throws {
        try tryShowError()
    }
    
    func getAvatar(id: String) async throws -> AvatarModel {
        guard let avatar = avatars.first(where: { $0.id == id}) else {
            throw URLError(.unknown)
        }
        
        try tryShowError()
        
        return avatar
    }
    
    func getFeaturedAvatars() async throws -> [AvatarModel] {
        try await Task.sleep(for: .seconds(delay))
        
        try tryShowError()
        
        return avatars
    }
    
    func getPopularAvatars() async throws -> [AvatarModel] {
        try await Task.sleep(for: .seconds(delay))
        
        try tryShowError()
        
        return avatars
    }
    
    func getAvatarsForCategory(category: CharacterOption) async throws -> [AvatarModel] {
        try await Task.sleep(for: .seconds(delay))
        
        try tryShowError()
        
        return avatars
    }
    
    func getAvatarsForAuthor(userId: String) async throws -> [AvatarModel] {
        try await Task.sleep(for: .seconds(delay))
        
        try tryShowError()
        
        return avatars
    }
    
    func incrementAvatarClickCount(avatarId: String) async throws { }
    
    func removeAuthorIdFromAvatar(avatarId: String) async throws { }
    
    func removeAuthorIdFromAllAvatars(userId: String) async throws { }
}
