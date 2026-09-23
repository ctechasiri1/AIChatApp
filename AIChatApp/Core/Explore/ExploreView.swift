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
    
    @State private var categories: [CharacterOption] = CharacterOption.allCases
    
    @State private var featuredAvatars: [AvatarModel] = []
    @State private var popularAvatars: [AvatarModel] = []
    
    @State private var isLoadingPopular: Bool = true
    @State private var isLoadingFeatured: Bool = true
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                if featuredAvatars.isEmpty && popularAvatars.isEmpty {
                    ZStack {
                        if isLoadingPopular || isLoadingFeatured {
                            loadingIndicator
                        } else {
                            errorMessageView
                        }
                    }
                    .removeListRowFormatting()
                }
                
                if !featuredAvatars.isEmpty {
                    featureSection
                }
                
                if !popularAvatars.isEmpty {
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
        guard featuredAvatars.isEmpty else { return }
        
        do {
            featuredAvatars = try await avatarManager.getFeaturedAvatars()
        } catch {
            print("Error loading featured avatars: \(error)")
        }
        isLoadingFeatured = false
    }
    
    private func loadPopularAvatars() async {
        guard popularAvatars.isEmpty else { return }
    
        do {
            popularAvatars = try await avatarManager.getPopularAvatars()
        } catch {
            print("Error loading popular avatars: \(error)")
        }
        isLoadingPopular = false
    }
    
    private func onTryAgainPressed() {
        isLoadingPopular = true
        isLoadingFeatured = true
        
        Task {
            await loadPopularAvatars()
        }
        Task {
            await loadFeaturedAvatars()
        }
    }
    
    private var loadingIndicator: some View {
        ProgressView()
            .padding(40)
            .frame(maxWidth: .infinity)
            .removeListRowFormatting()
    }
    
    private var errorMessageView: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("Error")
                .font(.headline)
            
            Text("Please check your internet connection and try again")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Button("Try Again") {
                onTryAgainPressed()
            }
        }
        .frame(maxWidth: .infinity)
        .multilineTextAlignment(.center)
        .padding(40)
    }
    
    private var featureSection: some View {
        Section {
            CarouselView(items: featuredAvatars) { avatar in
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

#Preview("Mock Data") {
    ExploreView()
        .environment(AvatarManager(remote: MockAvatarService()))
}

#Preview("Empty State") {
    ExploreView()
        .environment(AvatarManager(remote: MockAvatarService(avatars: [], delay: 2)))
}

#Preview("Test Loader") {
    ExploreView()
        .environment(AvatarManager(remote: MockAvatarService(delay: 5)))
}
