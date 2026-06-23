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
    
    var body: some View {
        NavigationStack {
            List {
                featureSection
                categorySection
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
            }
            .removeListRowFormatting()
        } header: {
            Text("FEATURED AVATARS")
        }
    }
    
    private var categorySection: some View {
        Section {
            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(characterOptions, id: \.self) { character in
                        CategoryCellView(
                            title: character.rawValue.capitalized,
                            imageName: Constants.randomImage
                        )
                    }
                }
            }
            .frame(height: 140)
            .scrollIndicators(.hidden)
            .scrollTargetLayout()
            .scrollTargetBehavior(.viewAligned)
            .removeListRowFormatting()
        } header: {
            Text("CATEGORIES")
        }
    }
}

#Preview {
    ExploreView()
}
