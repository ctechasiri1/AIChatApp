//
//  LocalUserPersistence.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 8/19/26.
//

import Foundation

protocol LocalUserPersistence {
    func getCurrentUser() -> UserModel?
    func saveCurrentUser(user: UserModel?) throws
}

struct FileManagerUserPersistence: LocalUserPersistence {
    
    private let key = "current_user"
    
    func getCurrentUser() -> UserModel? {
        try? FileManager.getDocument(key: key)
    }
    
    func saveCurrentUser(user: UserModel?) throws {
        try FileManager.saveDocument(key: key, value: user)
    }
}

struct MockFileManagerPersistence: LocalUserPersistence {
    
    let currentUser: UserModel?
    
    init(user: UserModel? = nil) {
        self.currentUser = user
    }
    
    func getCurrentUser() -> UserModel? { currentUser }
    
    func saveCurrentUser(user: UserModel?) throws { }
}
