//
//  UserManager.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 8/1/26.
//

import Foundation
import SwiftfulUtilities

@Observable
@MainActor
class UserManager {
    
    private let remote: RemoteUserService
    private let local: LocalUserPersistence
    private(set) var currentUser: UserModel?
    private var listenerTask: Task<Void, Error>?
    
    enum UserManagerError: LocalizedError {
        case noUserId
    }
    
    init(services: UserServices = MockUserServices()) {
        self.remote = services.remote
        self.local = services.local
        self.currentUser = nil
        self.currentUser = local.getCurrentUser()
        print("LOADED CURRENT USER ON LAUCH: \(currentUser?.userId)")
        print(NSHomeDirectory())
    }
    
    func loginIn(auth: UserAuthInfo, isNewUser: Bool) async throws {
        let creationVersion = isNewUser ? Utilities.appVersion : nil
        let user = UserModel(auth: auth, creationVersion: creationVersion)
        try await remote.saveUser(user: user)
        addCurrentUserListener(userId: auth.uid)
    }
    
    func markOnboardingCompleteCurrentUser(profileColorHex: String) async throws {
        guard let uid = currentUser?.userId else {
            throw UserManagerError.noUserId
        }
        try await remote.markOnboardingComplete(userId: uid, profileColorHex: profileColorHex)
    }
    
    func signOut() {
        listenerTask = nil
        listenerTask?.cancel()
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
    
    private func addCurrentUserListener(userId: String) {
        listenerTask = Task {
            do {
                for try await value in remote.streamUser(userId: userId) {
                    self.currentUser = value
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
