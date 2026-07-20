//
//  AIChatAppApp.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 6/8/26.
//

import Firebase
import SwiftUI

@main
struct AIChatAppApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            EnvironmentViewBuilder {
                AppView()
            }
        }
    }
}

struct EnvironmentViewBuilder<Content: View>: View {
    
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        content()
            .environment(\.authService, FirebaseAuthService())
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}
