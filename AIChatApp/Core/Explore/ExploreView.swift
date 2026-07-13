//
//  ExploreView.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 6/10/26.
//

import SwiftUI

enum NavigationPathOption: Hashable {
    case chat(avatarId: String)
    case category(category: CharacterOption, imageName: String)
}

extension View {
    func navigationDestinationForCore(path: Binding<[NavigationPathOption]>) -> some View {
        self
            .navigationDestination(for: NavigationPathOption.self) { value in
                switch value {
                case .chat(avatarId: let avatarId):
                    ChatView(avatarId: avatarId)
                case .category(
                    category: let category,
                    imageName: let imageName
                ):
                    CategoryListView(path: path, category: category, imageName: imageName)
                }
            }
    }
}

struct ExploreView: View {
    
    @State var path: [NavigationPathOption] = []
    
    @State private var avatars: [AvatarModel] = AvatarModel.mocks
    @State private var categories: [CharacterOption] = CharacterOption.allCases
    @State private var popularAvatars: [AvatarModel] = AvatarModel.mocks
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                featureSection
                categorySection
                popularSection
            }
            .navigationTitle("Explore")
            .navigationDestinationForCore(path: $path)
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
                    onAvatarPressed(avatar: avatar)
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
                    ForEach(categories, id: \.self) { category in
                        let imageName = popularAvatars.first(where: { $0.characterOption == category })?.profileImageName
                        
                        if let imageName {
                            CategoryCellView(
                                title: category.pural.capitalized,
                                imageName: Constants.randomImage
                            )
                            .anyButton {
                                onCategoryPressed(category: category, imageName: imageName)
                            }
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
                    onAvatarPressed(avatar: avatar)
                }
            }
            .removeListRowFormatting()
        } header: {
            Text("Popular".uppercased())
        }
    }
    
    private func onAvatarPressed(avatar: AvatarModel) {
        path.append(.chat(avatarId: avatar.avatarId))
    }
    
    private func onCategoryPressed(category: CharacterOption, imageName: String) {
        path.append(.category(category: category, imageName: imageName))
    }
}

#Preview {
    ExploreView()
}
