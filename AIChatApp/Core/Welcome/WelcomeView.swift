//
//  WelcomeView.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 6/10/26.
//

import SwiftUI

struct WelcomeView: View {
    
    @State private var showCreateAccountView: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                ImageLoaderView()
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    VStack {
                        titleSection
                            .padding(.top, 24)
                        
                        ctaSection
                            .padding(16)
                        
                        policyLinks
                            .padding(.bottom, 30)
                    }
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .ignoresSafeArea()
            }
            .sheet(isPresented: $showCreateAccountView) {
                CreateAccountView(
                    title: "Sign in",
                    description: "Connect to an existing account."
                )
                    .presentationDetents([.height(270)])
            }
        }
    }
    
    private var titleSection: some View {
        VStack(spacing: 8) {
            Text("AI Chat")
                .font(.system(.largeTitle, weight: .semibold))
            
            Text("Github @ctechasiri1")
                .font(.system(.subheadline))
                .foregroundStyle(.secondary)
        }
    }
    
    private var ctaSection: some View {
        VStack(spacing: 8) {
            NavigationLink {
                OnboardingIntroView()
            } label: {
                Text("Get Started")
                    .callToActionButtion()
            }
            
            Text("Already have an account? Sign in.")
                .underline()
                .padding(8)
                .tappableBackground()
                .onTapGesture {
                    onSignInPressed()
                }
        }
    }
    
    private func onSignInPressed() {
        showCreateAccountView = true
    }
    
    private var policyLinks: some View {
        HStack(spacing: 8) {
            Link(destination: URL(string: Constants.termsOfServiceURL)!) {
                Text("Terms of Service")
            }
            
            Circle()
                .frame(width: 4, height: 4)
            
            Link(destination: URL(string: Constants.privacyPolicyURL)!) {
                Text("Privacy Policy")
            }
        }
        .foregroundStyle(.accent)
    }
}

#Preview {
    NavigationStack {
        WelcomeView()
    }
}
