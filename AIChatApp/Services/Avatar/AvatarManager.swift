//
//  AvatarManager.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 9/13/26.
//


import Foundation
import UIKit

protocol AvatarService {
    func createAvatar(avatar: AvatarModel, image: UIImage) async throws
}

struct MockAvatarService: AvatarService {
    func createAvatar(avatar: AvatarModel, image: UIImage) async throws {
        
    }
}

import FirebaseFirestore
import SwiftfulFirestore

struct FirebaseAvatarService: AvatarService {
    
    var collection: CollectionReference {
        Firestore.firestore().collection("avatars")
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
}

@Observable
@MainActor
class AvatarManager {
    private let service: AvatarService
    
    init(service: AvatarService) {
        self.service = service
    }
    
    func createAvatar(avatar: AvatarModel, image: UIImage) async throws {
        try await service.createAvatar(avatar: avatar, image: image)
    }
}
