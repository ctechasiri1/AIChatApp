//
//  FirebaseAuthService.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 7/15/26.
//

import FirebaseAuth
import Foundation
import SwiftUI
import SignInAppleAsync

struct FirebaseAuthService: AuthService {
    enum AuthError: LocalizedError {
        case userNotFound
        
        var errorDescription: String? {
            switch self {
            case .userNotFound:
                return "Current authenticated user not found."
            }
        }
    }
    
    func getAuthenticatedUser() -> UserAuthInfo? {
        if let user = Auth.auth().currentUser {
            return UserAuthInfo(user: user)
        }
        return nil
    }
    
    func signInAnonymously() async throws -> (user: UserAuthInfo, isNewUser: Bool) {
        let result = try await Auth.auth().signInAnonymously()
        
        return result.asUserAuthInfo
    }
    
    func signInApple() async throws -> (user: UserAuthInfo, isNewUser: Bool) {
        let helper = SignInWithAppleHelper()
        let response = try await helper.signIn()
        
        let credential = OAuthProvider.credential(
            providerID: AuthProviderID.apple,
            idToken: response.token,
            rawNonce: response.nonce
        )
        
        if let user = Auth.auth().currentUser, user.isAnonymous {
            do {
                // try linking anonymous user to apple account
                let result = try await user.link(with: credential)
                return result.asUserAuthInfo
            } catch let error as NSError {
                let authError = AuthErrorCode(rawValue: error.code)
                switch authError {
                case .providerAlreadyLinked, .credentialAlreadyInUse:
                    // if apple account is already in use a new credentials to sign in with
                    if let secondaryCredential = error.userInfo["FIRAuthErrorUserInfoUpdatedCredentialKey"] as? AuthCredential {
                        let result = try await Auth.auth().signIn(with: secondaryCredential)
                        return result.asUserAuthInfo
                    }
                default:
                    break
                }
            }
        }
        
        // user is not anonymous default sign in
        let result = try await Auth.auth().signIn(with: credential)
        return result.asUserAuthInfo
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func deleteAccount() async throws {
        // checks if the current user exists
        guard let user = Auth.auth().currentUser else {
            throw AuthError.userNotFound
        }
        
        try await user.delete()
    }
}

extension AuthDataResult {
    var asUserAuthInfo: (user: UserAuthInfo, isNewUser: Bool) {
        let user = UserAuthInfo(user: user)
        let isNewUser = additionalUserInfo?.isNewUser ?? true
        
        return (user, isNewUser)
    }
}
