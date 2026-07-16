//
//  AppView.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 6/8/26.
//

import SwiftUI

struct AppView: View {
    
    @State var appState: AppState = AppState()
    @Environment(\.authService) private var authService
    
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
    }
    
    private func checkUserStatus() async {
        if let user = authService.getAuthenticatedUser() {
            print("The user is authenticated: \(user.uid)")
        } else {
            do {
                let result = try await authService.signInAnonymously()
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
