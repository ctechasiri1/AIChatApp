//
//  AvatarService.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 9/19/26.
//

import Foundation
import UIKit

protocol RemoteAvatarService {
    func createAvatar(avatar: AvatarModel, image: UIImage) async throws
    func getAvatar(id: String) async throws -> AvatarModel
    func getFeaturedAvatars() async throws -> [AvatarModel]
    func getPopularAvatars() async throws -> [AvatarModel]
    func getAvatarsForCategory(category: CharacterOption) async throws -> [AvatarModel]
    func getAvatarsForAuthor(userId: String) async throws -> [AvatarModel]
    func incrementAvatarClickCount(avatarId: String) async throws
    func removeAuthorIdFromAvatar(avatarId: String) async throws
    func removeAuthorIdFromAllAvatars(userId: String) async throws
}
