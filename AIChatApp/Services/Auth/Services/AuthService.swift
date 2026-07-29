//
//  AuthService.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 7/23/26.
//

import SwiftUI

extension EnvironmentValues {
    @Entry var authService: AuthService = MockAuthService()
}

protocol AuthService: Sendable {
    func getAuthenticatedUser() -> UserAuthInfo?
    func signInAnonymously() async throws -> (user: UserAuthInfo, isNewUser: Bool)
    func signInApple() async throws -> (user: UserAuthInfo, isNewUser: Bool)
    func signOut() throws
    func deleteAccount() async throws
}
