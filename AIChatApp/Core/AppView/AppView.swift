//
//  AppView.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 6/8/26.
//

import SwiftUI

struct AppView: View {
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
    }
}

#Preview("AppView - Tabbar") {
    AppView(appState: AppState())
}

#Preview("AppView - Onboarding") {
    AppView(appState: AppState())
}
