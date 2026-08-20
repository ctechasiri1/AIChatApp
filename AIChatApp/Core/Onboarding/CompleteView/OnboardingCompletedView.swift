//
//  OnboardingCompletedView.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 6/10/26.
//

import SwiftUI

struct OnboardingCompletedView: View {
    @Environment(AppState.self) private var appState
    @Environment(UserManager.self) private var userManager
    
    @State var selectedColor: Color = .orange
    @State private var isCompletingProfileSetup: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Setup Complete!")
                .font(.system(.largeTitle, weight: .semibold))
                .foregroundStyle(selectedColor)
            
            Text("We've set up your profile and you're ready to start chatting.")
                .font(.system(.title, weight: .medium))
                .foregroundStyle(.secondary)
        }
        .frame(maxHeight: .infinity)
        .safeAreaInset(edge: .bottom) {
            AsyncCallToActionButton(
                title: "Finish",
                isLoading: isCompletingProfileSetup) {
                    onFinishButtonPressed()
                }
        }
        .padding(24)
        .toolbar(.hidden, for: .navigationBar)
    }
    
    func onFinishButtonPressed() {
        isCompletingProfileSetup = true
        Task {
            do {
                let hex = selectedColor.asHex()
                try await userManager.markOnboardingCompleteCurrentUser(profileColorHex: hex)
                
                // dismiss the screen
                isCompletingProfileSetup = false
                appState.updateViewState(showTabBarView: true)
            } catch {
                
            }
        }
    }
}

#Preview {
    NavigationStack {
        OnboardingCompletedView()
    }
    .environment(AppState())
    .environment(UserManager(services: MockUserServices(currentUser: nil)))
}
