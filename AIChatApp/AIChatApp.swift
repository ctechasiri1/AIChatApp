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
                .environment(delegate.dependencies.userManager)
                .environment(delegate.dependencies.authManager)
                .environment(delegate.dependencies.aiManager)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    var dependencies: Dependencies!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        dependencies = Dependencies()
        
        return true
    }
}

struct Dependencies {
    var authManager: AuthManager
    var userManager: UserManager
    var aiManager: AIManager
    
    init() {
        self.authManager = AuthManager(service: FirebaseAuthService())
        self.userManager = UserManager(services: ProductionUserServices())
        self.aiManager = AIManager(service: OpenAIService())
    }
}
