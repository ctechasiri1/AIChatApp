//
//  FireBaseImageUploadService.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 9/13/26.
//

import FirebaseStorage
import Foundation
import UIKit

protocol ImageUploadService {
    func uploadImage(image: UIImage, path: String) async throws -> URL
}

struct FireBaseImageUploadService: ImageUploadService {
    func uploadImage(image: UIImage, path: String) async throws -> URL {
        guard let data = image.jpegData(compressionQuality: 1) else {
            throw URLError(.dataNotAllowed)
        }
        
        // Upload image
        _ = try await saveImage(data: data, path: path)
        
        // Get download url
        let url = try await imageReference(path: path).downloadURL()
        
        return url
    }
    
    private func imageReference(path: String) -> StorageReference {
        let name = "\(path).jpg"
        return Storage.storage().reference(withPath: name)
    }
    
    private func saveImage(data: Data, path: String) async throws -> URL {
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        let returnedMeta = try await imageReference(path: path).putDataAsync(data, metadata: meta)
        
        guard let returnedPath = returnedMeta.path, let url = URL(string: returnedPath) else {
            throw URLError(.badURL)
        }
        
        return url
    }
}
