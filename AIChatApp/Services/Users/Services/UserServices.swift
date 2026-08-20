//
//  UserServices.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 8/19/26.
//

import Foundation

protocol UserServices {
    var remote: RemoteUserService { get }
    var local: LocalUserPersistence { get }
}

struct ProductionUserServices: UserServices {
    var remote: RemoteUserService = FirebaseUserService()
    var local: LocalUserPersistence = FileManagerUserPersistence()
}

struct MockUserServices: UserServices {
    var remote: RemoteUserService
    var local: LocalUserPersistence
    
    init(currentUser: UserModel? = nil) {
        self.remote = MockUserService(user: currentUser)
        self.local = MockFileManagerPersistence(user: currentUser)
    }
}
