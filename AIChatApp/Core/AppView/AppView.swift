//
//  AppView.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 6/8/26.
//

import SwiftUI

struct AppView: View {
    @AppStorage("showTabbarView") var showTabbar: Bool = false
    
    var body: some View {
        AppViewBuilder(
            showTabbar: showTabbar,
            tabbarView: {
                TabBarView()
            },
            onboardingView: {
                WelcomeView()
            }
        )
        .onTapGesture {
            showTabbar.toggle()
        }
    }
}

#Preview("AppView - Tabbar") {
    AppView(showTabbar: true)
}

#Preview("AppView - Onboarding") {
    AppView(showTabbar: false)
}
