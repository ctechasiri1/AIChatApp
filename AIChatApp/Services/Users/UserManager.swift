//
//  UserManager.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 8/1/26.
//

import SwiftUI
import SwiftfulUtilities

@MainActor
@Observable
class UserManager {
    
    private let remote: RemoteUserService
    private let local: LocalUserPersistence
    
    private(set) var currentUser: UserModel?
    private var currentUserListener: Task<Void, Error>?
    
    enum UserManagerError: LocalizedError {
        case noUserId
    }
    
    init(services: UserServices) {
        self.remote = services.remote
        self.local = services.local
        self.currentUser = local.getCurrentUser()
    }
    
    func loginIn(auth: UserAuthInfo, isNewUser: Bool) async throws {
        let creationVersion = isNewUser ? Utilities.appVersion : nil
        let user = UserModel(auth: auth, creationVersion: creationVersion)
        try await remote.saveUser(user: user)
        addCurrentUserListener(userId: auth.uid)
    }
    
    func markOnboardingCompleteCurrentUser(profileColorHex: String) async throws {
        let uid = try currentUserId()
        try await remote.markOnboardingComplete(userId: uid, profileColorHex: profileColorHex)
    }
    
    func signOut() {
        currentUserListener = nil
        currentUserListener?.cancel()
        currentUser = nil
    }
    
    func deleteCurrentUser() async throws {
        guard let uid = currentUser?.userId else {
            throw UserManagerError.noUserId
        }
        print("\(uid)")
        try await remote.deleteUser(userId: uid)
        signOut()
    }
    
    private func currentUserId() throws -> String {
        guard let uid = currentUser?.userId else {
            throw UserManagerError.noUserId
        }
        return uid
    }
    
    private func addCurrentUserListener(userId: String) {
        currentUserListener = Task {
            do {
                for try await value in remote.streamUser(userId: userId) {
                    self.currentUser = value
                    self.saveCurrentUserToLocal()
                    print("Successfully listened to user: \(value.userId)")
                }
            } catch {
                print("Error attaching user listener: \(error)")
            }
        }
    }
    
    private func saveCurrentUserToLocal() {
        do {
            try local.saveCurrentUser(user: currentUser)
            print("Success saved current user locally")
        } catch {
            print("Error saving current user local:\(error)")
        }
    }
}
