//
//  ProfileView.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 6/10/26.
//

import SwiftUI

struct ProfileView: View {
    @Environment(UserManager.self) private var userManager
    @Environment(AvatarManager.self) private var avatarManager
    @Environment(AuthManager.self) private var authManager
    
    @State var path: [NavigationPathOption] = []
    
    @State private var currentUser: UserModel?
    @State private var myAvatars: [AvatarModel] = []
    
    @State private var showAlert: AnyAppAlert?
    
    @State private var showSettingsView: Bool = false
    @State private var showCreateAvatarView: Bool = false
    @State private var isLoading: Bool = true
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                myInfoSection
                myAvatarSection
            }
            .navigationTitle(
                "Profile"
            )
            .navigationDestinationForCoreModule(path: $path)
            .task {
                await loadData()
            }
            .toolbar {
                ToolbarItem(
                    placement: .topBarTrailing
                ) {
                    settingsButton
                }
            }
            .sheet(
                isPresented: $showSettingsView
            ) {
                SettingsView()
            }
            .fullScreenCover(isPresented: $showCreateAvatarView, onDismiss: {
                Task {
                    await loadData()
                }
            }, content: {
                CreateAvatarView()
            })
        }
    }
    
    private var myInfoSection: some View {
        Section {
            ZStack {
                Circle()
                    .fill(currentUser?.profileColorCalculated ?? .accent)
            }
            .frame(width: 100, height: 100)
            .frame(maxWidth: .infinity)
            .removeListRowFormatting()
        }
    }
    
    private var myAvatarSection: some View {
        Section {
            Group {
                if myAvatars.isEmpty {
                    Group {
                        if isLoading {
                            ProgressView()
                        } else {
                            Text("Click + to create an avatar")
                        }
                    }
                    .padding(50)
                    .frame(maxWidth: .infinity)
                    .font(.body)
                    .foregroundStyle(.secondary)
                } else {
                    ForEach(myAvatars, id: \.self) { avatar in
                        CustomListCellView(
                            imageName: avatar.profileImageName,
                            title: avatar.name,
                            description: nil
                        )
                        .anyButton(.highlight) {
                            onAvatarPressed(avatar: avatar)
                        }
                    }
                    .onDelete { indexSet in
                        onDeleteAvatar(indexSet: indexSet)
                    }
                }
            }
            .removeListRowFormatting()
        } header: {
            HStack(spacing: 0) {
                Text("My Avatars")
                
                Spacer()
                
                Image(systemName: "plus.circle.fill")
                    .font(.title)
                    .foregroundStyle(.accent)
                    .anyButton {
                        onCreateNewAvatarPressed()
                    }
            }
        }
    }
    
    private var settingsButton: some View {
        Image(systemName: "gear")
            .anyButton {
                onSettingsButtonPressed()
            }
    }
    
    private func loadData() async {
        self.currentUser = userManager.currentUser
        do {
            let uid = try authManager.getAuthId()
            myAvatars = try await avatarManager.getAvatarForAuthor(userId: uid)
        } catch {
            print("Failed to fetch user avatars.")
        }
        isLoading = false
    }
    
    private func onDeleteAvatar(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let avatar = myAvatars[index]
        
        Task {
            do {
                try await avatarManager.removeAuthorIdFromAvatar(avatarId: avatar.id)
                myAvatars.remove(at: index)
            } catch {
                showAlert = AnyAppAlert(title: "Unable to delete avatar.", subtitle: "Please try again")
            }
        }
    }
    
    private func onSettingsButtonPressed() {
        showSettingsView = true
    }
    
    private func onCreateNewAvatarPressed() {
        showCreateAvatarView = true
    }
    
    private func onAvatarPressed(avatar: AvatarModel) {
        path.append(.chat(avatarId: avatar.avatarId))
    }
}

#Preview {
    ProfileView()
        .previewEnvironment()
}
