//
//  UserAuthInfo.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 7/20/26.
//

import SwiftUI

struct UserAuthInfo: Sendable {
    let uid: String
    let email: String?
    let isAnonymous: Bool
    let creationDate: Date?
    let lastSignInDate: Date?
    
    init(uid: String, email: String?, isAnonymous: Bool, creationDate: Date?, lastSignInDate: Date?) {
        self.uid = uid
        self.email = email
        self.isAnonymous = isAnonymous
        self.creationDate = creationDate
        self.lastSignInDate = lastSignInDate
    }
    
    static func mock(isAnonymous: Bool = false) -> Self {
        UserAuthInfo(
            uid: "mock_user_123",
            email: "hello@gmail.com",
            isAnonymous: isAnonymous,
            creationDate: .now,
            lastSignInDate: .now
        )
    }
}
