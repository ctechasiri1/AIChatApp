//
//  CategoryListView.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 7/12/26.
//

import SwiftUI

struct CategoryListView: View {
    
    var character: CharacterOption = .alien
    var imageName: String = Constants.randomImage
    @State private var avatars: [AvatarModel] = AvatarModel.mocks
    
    var body: some View {
        List {
            CategoryCellView(
                title: character.pural.capitalized,
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
                .removeListRowFormatting()
            }
        }
        .ignoresSafeArea()
        .listStyle(PlainListStyle())
    }
}

#Preview {
    CategoryListView()
}
