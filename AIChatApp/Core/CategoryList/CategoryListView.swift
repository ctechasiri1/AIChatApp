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
            
            if avatars.isEmpty && isLoading {
                ProgressView()
                    .padding(40)
                    .frame(maxWidth: .infinity)
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

#Preview {
    @State @Previewable var path: [NavigationPathOption] = []
    
    CategoryListView(path: $path)
        .environment(AvatarManager(remote: MockAvatarService()))
}
