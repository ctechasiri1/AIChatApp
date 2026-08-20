//
//  AIChatApp.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 6/8/26.
//

import Firebase
import SwiftUI

@main
struct AIChatApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            AppView()
                .environment(delegate.userManager)
                .environment(delegate.authManager)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    var authManager: AuthManager!
    var userManager: UserManager!
    
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    FirebaseApp.configure()
      authManager = AuthManager(service: FirebaseAuthService())
      userManager = UserManager(services: ProductionUserServices())

    return true
  }
}
