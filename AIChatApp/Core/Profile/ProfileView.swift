//
//  ProfileView.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 6/10/26.
//

import SwiftUI

struct ProfileView: View {
    
    @State private var currentUser: UserModel = .mock
    @State private var myAvatars: [AvatarModel] = []
    @State private var showSettingsView: Bool = false
    @State private var showCreateAvatarView: Bool = false
    @State private var isLoading: Bool = true
    
    var body: some View {
        NavigationStack {
            List {
                myInfoSection
                myAvatarSection
            }
            .navigationTitle(
                "Profile"
            )
            .task {
               await getData()
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
            .fullScreenCover(isPresented: $showCreateAvatarView) {
                Text("Add New Avatar")
            }
        }
    }
    
    private var myInfoSection: some View {
        Section {
            ZStack {
                Circle()
                    .fill(currentUser.profileColorCalculated)
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
    
    private func getData() async {
        try? await Task.sleep(for: .seconds(5))
        isLoading = false
        myAvatars = AvatarModel.mocks
    }
    
    private func onDeleteAvatar(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        myAvatars.remove(at: index)
    }
    
    private func onSettingsButtonPressed() {
        showSettingsView = true
    }
    
    private func onCreateNewAvatarPressed() {
        showCreateAvatarView = true
    }
}

#Preview {
    ProfileView()
        .environment(AppState())
}
