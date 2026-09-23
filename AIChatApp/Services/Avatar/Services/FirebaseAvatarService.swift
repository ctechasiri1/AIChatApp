//
//  FirebaseAvatarService.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 9/19/26.
//

import FirebaseFirestore
import Foundation
import SwiftfulFirestore

struct FirebaseAvatarService: RemoteAvatarService {
    var collection: CollectionReference {
        Firestore.firestore().collection("avatars")
    }
    
    func getAvatar(id: String) async throws -> AvatarModel {
        try await collection.getDocument(id: id)
    }
    
    func incrementAvatarClickCount(avatarId: String) async throws {
        try await collection
            .document(avatarId)
            .updateData([AvatarModel.CodingKeys.clickCount.rawValue: FieldValue.increment(Int64(1))])
    }
    
    func createAvatar(avatar: AvatarModel, image: UIImage) async throws {
        // Upload image
        let path = "avatars/\(avatar.avatarId)"
        let url = try await FireBaseImageUploadService().uploadImage(image: image, path: path)
        
        // Update the avatar image name
        var avatar = avatar
        avatar.updateImage(imageName: url.absoluteString)
        
        // Upload the avatar
        try collection.document(avatar.avatarId).setData(from: avatar, merge: true)
    }
    
    func getFeaturedAvatars() async throws -> [AvatarModel] {
        try await collection
            .limit(to: 50)
            .getAllDocuments()
            .shuffled()
            .first(upTo: 5) ?? []
    }
    
    func getPopularAvatars() async throws -> [AvatarModel] {
        try await collection
            .order(by: AvatarModel.CodingKeys.clickCount.rawValue, descending: true)
            .limit(to: 200)
            .getAllDocuments()
    }
    
    func getAvatarsForCategory(category: CharacterOption) async throws -> [AvatarModel] {
        try await collection
            .whereField(AvatarModel.CodingKeys.characterOption.rawValue, isEqualTo: category.rawValue)
            .limit(to: 200)
            .getAllDocuments()
    }
    
    func getAvatarsForAuthor(userId: String) async throws -> [AvatarModel] {
        try await collection
            .whereField(AvatarModel.CodingKeys.authorId.rawValue, isEqualTo: userId)
            .order(by: AvatarModel.CodingKeys.clickCount.rawValue, descending: true)
            .getAllDocuments()
    }
}
