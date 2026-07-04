//
//  SettingsView.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 6/10/26.
//

import SwiftUI
import SwiftfulUtilities

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppState.self) private var appState
    
    @State private var isPremium: Bool = true
    @State private var isAnonymousUser: Bool = true
    @State private var showCreateAccountView: Bool = true
    
    var body: some View {
        NavigationStack {
            List {
                accountSection
                purchaseSection
                applicationSection
            }
            .navigationTitle("Settings")
        }
        .sheet(isPresented: $showCreateAccountView) {
            CreateAccountView()
                .presentationDetents([.height(270)])
        }
    }
    
    var accountSection: some View {
        Section {
            Group {
                if isAnonymousUser {
                    Text("Save & back-up account")
                        .rowFormatting()
                        .anyButton(.highlight) {
                            onPressedButtonSignOut()
                        }
                } else {
                    Text("Sign out")
                        .rowFormatting()
                        .anyButton(.highlight) {
                            onPressedButtonSignOut()
                        }
                }
  
                Text("Delete account")
                    .foregroundStyle(.red)
                    .rowFormatting()
                    .anyButton(.highlight) {
                        
                    }
            }
            .removeListRowFormatting()
        } header: {
            Text("Account")
        }
    }
    
    var purchaseSection: some View {
        Section {
            HStack {
                Text("Account status: \(isPremium ? "PREMIUM" : "FREE")")
                
                Spacer()
                
                if isPremium {
                    Text("Manage")
                        .blueBadge()
                }
            }
            .rowFormatting()
            .anyButton(.highlight) {
                
            }
            .removeListRowFormatting()
        } header: {
            Text("Purchases")
        }

    }
    
    var applicationSection: some View {
        Section {
            HStack(spacing: 8) {
                Text("Version")
                
                Spacer()
                
                Text(Utilities.appVersion ?? "")
                    .foregroundStyle(.secondary)
            }
            .rowFormatting()
            .removeListRowFormatting()
            
            HStack(spacing: 8) {
                Text("Build Number")
                
                Spacer()
                
                Text(Utilities.buildNumber ?? "")
                    .foregroundStyle(.secondary)
            }
            .rowFormatting()
            .removeListRowFormatting()
            
            Text("Contact account")
                .foregroundStyle(.blue)
                .rowFormatting()
                .anyButton(.highlight, action: {
                    
                })
                .removeListRowFormatting()
            
        } header: {
            Text("Application")
        }
    }
    
    func onPressedButtonSignOut() {
        dismiss()
        Task {
            try? await Task.sleep(for: .seconds(1))
            appState.updateViewState(showTabBarView: false)
        }
    }
    
    func onCreateAccountPressed() {
        showCreateAccountView = true
    }
}

fileprivate extension View {
    func rowFormatting() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .background(Color(uiColor: .systemBackground))
    }
}

#Preview {
    SettingsView()
        .environment(AppState())
}
