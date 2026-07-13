//
//  CategoryListView.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 7/12/26.
//

import SwiftUI

struct CategoryListView: View {
    
    @Binding var path: [NavigationPathOption]
    
    var category: CharacterOption = .alien
    var imageName: String = Constants.randomImage
    @State private var avatars: [AvatarModel] = AvatarModel.mocks
    
    var body: some View {
        List {
            CategoryCellView(
                title: category.pural.capitalized,
                imageName: imageName,
                font: .largeTitle,
                cornderRadius: 0
            )
            .removeListRowFormatting()
            
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
        .ignoresSafeArea()
        .listStyle(PlainListStyle())
        .navigationDestinationForCore(path: $path)
    }
    
    private func onAvatarPressed(avatar: AvatarModel) {
        path.append(.chat(avatarId: avatar.avatarId))
    }
}

#Preview {
    @State @Previewable var path: [NavigationPathOption] = []
    
    CategoryListView(path: $path)
}
