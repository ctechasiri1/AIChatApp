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
    @Environment(AuthManager.self) private var authManager
    @Environment(AppState.self) private var appState
    
    @State private var isPremium: Bool = false
    @State private var isAnonymousUser: Bool = false
    @State private var showCreateAccountView: Bool = false
    @State private var showAlert: AnyAppAlert?
    
    var body: some View {
        NavigationStack {
            List {
                accountSection
                purchaseSection
                applicationSection
            }
            .navigationTitle("Settings")
        }
        .sheet(isPresented: $showCreateAccountView,
        onDismiss: {
            setAnonymousAccountStatus()
        }, content: {
            CreateAccountView()
                .presentationDetents([.height(270)])
        })
        .onAppear {
            setAnonymousAccountStatus()
        }
        .showCustomAlert(alert: $showAlert)
    }
    
    var accountSection: some View {
        Section {
            Group {
                if isAnonymousUser {
                    Text("Save & back-up account")
                        .rowFormatting()
                        .anyButton(.highlight) {
                            onCreateAccountPressed()
                        }
                } else {
                    Text("Sign out")
                        .rowFormatting()
                        .anyButton(.highlight) {
                            onSignOutButtonPressed()
                        }
                }
  
                Text("Delete account")
                    .foregroundStyle(.red)
                    .rowFormatting()
                    .anyButton(.highlight) {
                        onDeleteButtonPressed()
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
    
    func onSignOutButtonPressed() {
        Task {
            do {
                try authManager.signOut()
                await dismissScreen()
            } catch {
                showAlert = AnyAppAlert(error: error)
            }
        }
    }
    
    func onDeleteButtonPressed() {
        showAlert = AnyAppAlert(
            title: "Delete Account?",
            subtitle: "This is action is permanent and can't be undone. Your data will be deleted from our server forever.",
            buttons: {
                AnyView(
                    Button("Delete", role: .destructive, action: {
                        onDeleteAccountConfirmed()
                    })
                )
            }
        )
    }
    
    func onCreateAccountPressed() {
        showCreateAccountView = true
    }
    
    // Checks if the authenticated user is anonymous and sets our private var
    func setAnonymousAccountStatus() {
        isAnonymousUser = authManager.auth?.isAnonymous == true
    }
    
    func dismissScreen() async {
        dismiss()
        try? await Task.sleep(for: .seconds(1))
        appState.updateViewState(showTabBarView: false)
    }

    func onDeleteAccountConfirmed() {
        Task {
            do {
                try await authManager.deleteAccount()
                await dismissScreen()
            } catch {
                showAlert = AnyAppAlert(error: error)
            }
        }
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

#Preview("Not Authenthicated") {
    SettingsView()
        .environment(AuthManager(service: MockAuthService(user: nil)))
        .environment(AppState())
}

#Preview("Anonymous") {
    SettingsView()
        .environment(AuthManager(service: MockAuthService(user: UserAuthInfo.mock(isAnonymous: true))))
        .environment(AppState())
}

#Preview("Not Anonymous") {
    SettingsView()
        .environment(AuthManager(service: MockAuthService(user: UserAuthInfo.mock(isAnonymous: false))))
        .environment(AppState())
}
