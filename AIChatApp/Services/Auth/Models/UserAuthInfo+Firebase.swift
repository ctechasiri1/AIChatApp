//
//  UserAuthInfo+Firebase.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 7/17/26.
//

import FirebaseAuth
import Foundation

extension UserAuthInfo {
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.isAnonymous = user.isAnonymous
        self.creationDate = user.metadata.creationDate
        self.lastSignInDate = user.metadata.lastSignInDate
    }
}
