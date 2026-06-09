//
//  AppViewBuilder.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 6/8/26.
//

import SwiftUI

struct AppViewBuilder<TabbarView: View, OnboardingView: View>: View {
    
    var showTabbar: Bool
    @ViewBuilder var tabbarView: TabbarView
    @ViewBuilder var onboardingView: OnboardingView
    
    var body: some View {
        ZStack {
            if showTabbar {
                onboardingView
                    .transition(.move(edge: .trailing))
            } else {
                tabbarView
                    .transition(.move(edge: .leading))
            }
        }
        .animation(.smooth, value: showTabbar)
    }
}
