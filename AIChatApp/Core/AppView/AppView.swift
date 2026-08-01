//
//  AppView.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 6/8/26.
//

import SwiftUI

struct AppView: View {
    
    @Environment(AuthManager.self) private var authManager
    @State var appState: AppState = AppState()
    
    var body: some View {
        AppViewBuilder(
            showTabbar: appState.showTabBar,
            tabbarView: {
                TabBarView()
            },
            onboardingView: {
                WelcomeView()
            }
        )
        .environment(appState)
        .task {
            await checkUserStatus()
        }
        // logout or delete account will trigger change from tab view to welcome view which will generate a new anonymous id
        .onChange(of: appState.showTabBar) { _, showTabBar in
            Task {
                if !showTabBar {
                    await checkUserStatus()
                }
            }
        }
    }
    
    private func checkUserStatus() async {
        if let user = authManager.auth {
            print("The user is authenticated: \(user.uid)")
        } else {
            do {
                let result = try await authManager.signInAnonymously()
                print("The account has been created: \(result.user.uid)")
            } catch {
                print(error)
            }
        }
    }
}

#Preview("AppView - Tabbar") {
    AppView(appState: AppState())
}

#Preview("AppView - Onboarding") {
    AppView(appState: AppState())
}
