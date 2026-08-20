//
//  RemoteUserService.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 8/19/26.
//


protocol RemoteUserService: Sendable {
    func saveUser(user: UserModel) async throws
    func streamUser(userId: String) -> AsyncThrowingStream<UserModel, Error>
    func markOnboardingComplete(userId: String, profileColorHex: String) async throws
    func deleteUser(userId: String) async throws
}

import FirebaseFirestore
import SwiftfulFirestore

typealias ListenerRegistration = FirebaseFirestore.ListenerRegistration

struct FirebaseUserService: RemoteUserService {
    
    var colleciton: CollectionReference {
        Firestore.firestore().collection("users")
    }
    
    func saveUser(user: UserModel) async throws {
        try colleciton.document(user.userId).setData(from: user, merge: true)
    }
    
    func streamUser(userId: String) -> AsyncThrowingStream<UserModel, Error> {
        colleciton.streamDocument(id: userId)
    }
    
    func markOnboardingComplete(userId: String, profileColorHex: String) async throws {
        try await colleciton.document(userId).updateData([
            UserModel.CodingKeys.didCompleteOnboarding.rawValue: true,
            UserModel.CodingKeys.profileColorHex.rawValue: profileColorHex
        ])
    }
    
    func deleteUser(userId: String) async throws {
        try await colleciton.document(userId).delete()
    }
}

struct MockUserService: RemoteUserService {
    
    let currentUser: UserModel?
    
    init(user: UserModel? = nil) {
        self.currentUser = user
    }
    
    func saveUser(user: UserModel) async throws { }
    
    func streamUser(userId: String) -> AsyncThrowingStream<UserModel, any Error> {
        AsyncThrowingStream { continuation in
            if let currentUser {
                continuation.yield(currentUser)
            }
        }
    }
    
    func markOnboardingComplete(userId: String, profileColorHex: String) async throws { }
    
    func deleteUser(userId: String) async throws { }
}
