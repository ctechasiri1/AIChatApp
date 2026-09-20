//
//  AvatarManager.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 9/13/26.
//

import SwiftData

@MainActor
protocol LocalAvatarPersistence {
    func addRecentActivity(avatar: AvatarModel) throws
    func getRecentAvatars() throws -> [AvatarModel]
}

@MainActor
struct MockAvatarPersistence: LocalAvatarPersistence {
    func addRecentActivity(avatar: AvatarModel) throws { }
    
    func getRecentAvatars() throws -> [AvatarModel] {
        AvatarModel.mocks.shuffled()
    }
}

@MainActor
struct SwiftDataLocalAvatarPersistence: LocalAvatarPersistence {
    private let container: ModelContainer
    private var mainContext: ModelContext {
        container.mainContext
    }
    
    init() {
        self.container = try! ModelContainer(for: AvatarEntity.self)
    }
    
    func addRecentActivity(avatar: AvatarModel) throws {
        let entity = AvatarEntity(from: avatar)
        mainContext.insert(entity)
        try mainContext.save()
    }
    
    func getRecentAvatars() throws -> [AvatarModel] {
        let descriptor = FetchDescriptor<AvatarEntity>(sortBy: [SortDescriptor(\.dateAdded, order: .reverse)])
        let entities = try mainContext.fetch(descriptor)
        return entities.map { $0.toModel() }
    }
}

@Model
class AvatarEntity {
    @Attribute(.unique) var avatarId: String
    var name: String?
    var characterOption: CharacterOption?
    var characterAction: CharacterAction?
    var characterLocation: CharacterLocation?
    var profileImageName: String?
    var authorId: String?
    var dateCreated: Date?
    var dateAdded: Date?
    
    init(from model: AvatarModel) {
        self.avatarId = model.avatarId
        self.name = model.name
        self.characterOption = model.characterOption
        self.characterAction = model.characterAction
        self.characterLocation = model.characterLocation
        self.profileImageName = model.profileImageName
        self.authorId = model.authorId
        self.dateCreated = model.dateCreated
        self.dateAdded = .now
    }
    
    func toModel() -> AvatarModel {
        AvatarModel(
            avatarId: avatarId,
            name: name,
            characterOption: characterOption,
            characterAction: characterAction,
            characterLocation: characterLocation,
            profileImageName: profileImageName,
            authorId: authorId,
            dateCreated: dateCreated
        )
    }
}

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
