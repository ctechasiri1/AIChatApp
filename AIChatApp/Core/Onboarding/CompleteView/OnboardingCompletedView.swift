//
//  OnboardingCompletedView.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 6/10/26.
//

import SwiftUI

struct OnboardingCompletedView: View {
    @Environment(AppState.self) private var appState
    
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
            ctaButton
        }
        .padding(24)
        .toolbar(.hidden, for: .navigationBar)
    }
    
    private var ctaButton: some View {
        Button {
            onFinishButtonPressed()
        } label: {
            ZStack {
                if isCompletingProfileSetup {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Finish")
                }
            }
            .callToActionButtion()
        }
        .disabled(isCompletingProfileSetup)
    }
    
    func onFinishButtonPressed() {
        isCompletingProfileSetup = true
        Task {
            /// this is to simulate an API call
            try await Task.sleep(for: .seconds(3))
            // try await saveSelectedColor(selectedColor: Color)
            isCompletingProfileSetup = false

            appState.updateViewState(showTabBarView: true)
        }
    }
}

#Preview {
    NavigationStack {
        OnboardingCompletedView()
    }
    .environment(AppState())
}
