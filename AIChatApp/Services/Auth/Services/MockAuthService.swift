//
//  MockAuthService.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 7/23/26.
//


struct MockAuthService: AuthService {
    
    let currentUser: UserAuthInfo?
    
    init(user: UserAuthInfo? = nil) {
        self.currentUser = user
    }
    
    func getAuthenticatedUser() -> UserAuthInfo? {
        print("getAuthenticatedUser getting called \(currentUser?.isAnonymous)")
        return currentUser
    }
    
    func signInAnonymously() async throws -> (user: UserAuthInfo, isNewUser: Bool) {
        let user = UserAuthInfo.mock(isAnonymous: true)
        return (user, true)
    }
    
    func signInApple() async throws -> (user: UserAuthInfo, isNewUser: Bool) {
        let user = UserAuthInfo.mock(isAnonymous: false)
        return (user, false)
    }
    
    func signOut() throws {
    
    }
    
    func deleteAccount() async throws {

    }
}