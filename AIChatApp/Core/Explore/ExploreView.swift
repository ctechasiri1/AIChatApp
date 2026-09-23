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

struct ExploreView: View {
    @Environment(AvatarManager.self) private var avatarManager
    
    @State var path: [NavigationPathOption] = []
    
    @State private var avatars: [AvatarModel] = []
    @State private var categories: [CharacterOption] = CharacterOption.allCases
    @State private var popularAvatars: [AvatarModel] = []
    @State private var isLoading: Bool = true
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                if avatars.isEmpty && isLoading {
                    ProgressView()
                        .padding(40)
                        .frame(maxWidth: .infinity)
                        .removeListRowFormatting()
                }
                
                if !avatars.isEmpty {
                    featureSection
                }
                
                if !categories.isEmpty {
                    categorySection
                    popularSection
                }
            }
            .navigationTitle("Explore")
            .navigationDestinationForCoreModule(path: $path)
        }
        .task {
            await loadPopularAvatars()
        }
        .task {
            await loadFeaturedAvatars()
        }
    }
    
    private func loadFeaturedAvatars() async {
        guard avatars.isEmpty else { return }
        
        do {
            avatars = try await avatarManager.getFeaturedAvatars()
        } catch {
            print("Error loading featured avatars: \(error)")
        }
        isLoading = false
    }
    
    private func loadPopularAvatars() async {
        guard popularAvatars.isEmpty else { return }
        
        do {
            popularAvatars = try await avatarManager.getPopularAvatars()
        } catch {
            print("Error loading popular avatars: \(error)")
        }
        isLoading = false
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
                        let imageName = popularAvatars.last(where: { $0.characterOption == category })?.profileImageName
                        
                        if let imageName {
                            CategoryCellView(
                                title: category.pural.capitalized,
                                imageName: imageName
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
                    imageName: avatar.profileImageName,
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
        .environment(AvatarManager(remote: MockAvatarService()))
}
