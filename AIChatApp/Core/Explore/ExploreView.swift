//
//  ExploreView.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 6/10/26.
//

import SwiftUI

struct ExploreView: View {
    
    @State private var avatars: [AvatarModel] = AvatarModel.mocks
    @State private var characterOptions: [CharacterOption] = CharacterOption.allCases
    @State private var popularAvatars: [AvatarModel] = AvatarModel.mocks
    
    var body: some View {
        NavigationStack {
            List {
                featureSection
                categorySection
                popularSection
            }
            .navigationTitle("Explore")
        }
    }
    
    private var featureSection: some View {
        Section {
            CarouselView(items: avatars) { avatar in
                HeroCellView(
                    title: avatar.name,
                    subtitle: avatar.characterDescription,
                    imageName: avatar.profileImageName
                )
                .anyButton(.press) {
                    
                }
            }
            .removeListRowFormatting()
        } header: {
            Text("Featured".uppercased())
        }
    }
    
    private var categorySection: some View {
        Section {
            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(characterOptions, id: \.self) { character in
                        CategoryCellView(
                            title: character.pural.capitalized,
                            imageName: Constants.randomImage
                        )
                        .anyButton {
                            
                        }
                    }
                }
            }
            .frame(height: 140)
            .scrollIndicators(.hidden)
            .scrollTargetLayout()
            .scrollTargetBehavior(.viewAligned)
            .removeListRowFormatting()
        } header: {
            Text("Categories".uppercased())
        }
    }
    
    private var popularSection: some View {
        Section {
            ForEach(popularAvatars, id: \.self) { avatar in
                CustomListCellView(
                    title: avatar.name,
                    description: avatar.characterDescription
                )
                .anyButton(.highlight) {
                    
                }
            }
            .removeListRowFormatting()
        } header: {
            Text("Popular".uppercased())
        }
    }
}

#Preview {
    ExploreView()
}
