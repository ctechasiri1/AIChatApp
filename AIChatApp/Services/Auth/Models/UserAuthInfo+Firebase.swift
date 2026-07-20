//
//  UserAuthInfo+Firebase.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 7/20/26.
//

import FirebaseAuth

extension UserAuthInfo {
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.isAnonymous = user.isAnonymous
        self.creationDate = user.metadata.creationDate
        self.lastSignInDate = user.metadata.lastSignInDate
    }
}
