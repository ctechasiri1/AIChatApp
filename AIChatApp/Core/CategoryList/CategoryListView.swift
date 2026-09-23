//
//  CategoryListView.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 7/12/26.
//

import SwiftUI

struct CategoryListView: View {
    @Environment(AvatarManager.self) private var avatarManager
    
    @Binding var path: [NavigationPathOption]
    
    var category: CharacterOption = .alien
    var imageName: String = Constants.randomImage
    @State private var avatars: [AvatarModel] = []
    @State private var showAlert: AnyAppAlert?
    @State private var isLoading: Bool = true
    
    var body: some View {
        List {
            CategoryCellView(
                title: category.pural.capitalized,
                imageName: imageName,
                font: .largeTitle,
                cornderRadius: 0
            )
            .removeListRowFormatting()
            
            if isLoading {
                ProgressView()
                    .padding(40)
                    .frame(maxWidth: .infinity)
                    .listRowSeparator(.hidden)
                    .removeListRowFormatting()
            } else if avatars.isEmpty {
                Text("There are no avatars found")
                    .frame(maxWidth: .infinity)
                    .padding(40)
                    .listRowSeparator(.hidden)
                    .removeListRowFormatting()
            } else {
                ForEach(avatars, id: \.self) { avatar in
                    CustomListCellView(
                        imageName: avatar.profileImageName,
                        title: avatar.name,
                        description: avatar.characterDescription
                    )
                    .anyButton(.highlight) {
                        onAvatarPressed(avatar: avatar)
                    }
                    .removeListRowFormatting()
                }
            }
        }
        .ignoresSafeArea()
        .listStyle(PlainListStyle())
        .showCustomAlert(alert: $showAlert)
        .task {
            await loadAvatars()
        }
    }
    
    private func onAvatarPressed(avatar: AvatarModel) {
        path.append(.chat(avatarId: avatar.avatarId))
    }
    
    private func loadAvatars() async {
        do {
            avatars = try await avatarManager.getAvatarsForCategory(category: category)
        } catch {
            showAlert = AnyAppAlert(error: error)
        }
        isLoading = false
    }
}

#Preview("Mock Data") {
    @State @Previewable var path: [NavigationPathOption] = []
    
    CategoryListView(path: $path)
        .environment(AvatarManager(remote: MockAvatarService()))
}

#Preview("Empty State") {
    @State @Previewable var path: [NavigationPathOption] = []
    
    CategoryListView(path: $path)
        .environment(AvatarManager(remote: MockAvatarService(avatars: [], delay: 2)))
}

#Preview("Test Loader") {
    @State @Previewable var path: [NavigationPathOption] = []
    
    CategoryListView(path: $path)
        .environment(AvatarManager(remote: MockAvatarService(delay: 5)))
}

#Preview("Show Error Modal") {
    @State @Previewable var path: [NavigationPathOption] = []
    
    CategoryListView(path: $path)
        .environment(AvatarManager(remote: MockAvatarService(delay: 2, showError: true)))
}
