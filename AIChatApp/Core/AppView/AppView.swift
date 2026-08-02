//
//  AppView.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 6/8/26.
//

import SwiftUI

struct AppView: View {
    
    @Environment(AuthManager.self) private var authManager
    @Environment(UserManager.self) private var userManager
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
            // this user is authenticated (this user has an account)
            print("The user is authenticated: \(user.uid)")
            
            // saving the user to the DB and update the DB with any new info
            do {
                try await userManager.loginIn(auth: user, isNewUser: false)
            } catch {
                print("Failed to login to auth for existing user: \(error)")
                // this mechanism will try to login again
                try? await Task.sleep(for: .seconds(5))
                await checkUserStatus()
            }
        } else {
            // this user is not authenticated
            do {
                let result = try await authManager.signInAnonymously()
                print("The account has been created: \(result.user.uid)")
                
                // login to the app
                try await userManager.loginIn(auth: result.user, isNewUser: true)
            } catch {
                print("Failed to sign in anonymously and login: \(error)")
                try? await Task.sleep(for: .seconds(5))
                await checkUserStatus()
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
