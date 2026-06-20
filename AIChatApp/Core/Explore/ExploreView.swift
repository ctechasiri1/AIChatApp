//
//  ExploreView.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 6/10/26.
//

import SwiftUI

struct ExploreView: View {
    
    let avatar = AvatarModel.mock
    
    var body: some View {
        NavigationStack {
            HeroCellView(title: avatar.name, subtitle: avatar.characterDescription, imageName: avatar.profileImageName)
                .frame(height: 200)
                .navigationTitle("Explore")
        }
    }
}

#Preview {
    ExploreView()
}
