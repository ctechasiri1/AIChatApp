//
//  ProfileModalView.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 7/10/26.
//

import SwiftUI

struct ProfileModalView: View {
    
    var imageName: String? = Constants.randomImage
    var title: String? = "Alpha"
    var subtitle: String? = "Alien"
    var headline: String? = "An alien in the park."
    var onXMarkPressed: () -> Void = { }
    
    var body: some View {
        VStack(spacing: 0) {
            if let imageName {
                ImageLoaderView(urlString: imageName, forceTransitionAnimation: true)
                    .aspectRatio(1, contentMode: .fit)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                if let title {
                    Text(title)
                        .font(.system(.title, weight: .semibold))
                }
                
                if let subtitle {
                    Text(subtitle)
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                
                if let headline {
                    Text(headline)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(alignment: .topTrailing) {
            Image(systemName: "x.circle.fill")
                .font(.title2)
                .padding(4)
                .tappableBackground()
                .anyButton {
                    onXMarkPressed()
                }
                .padding(8)
        }
    }
}

#Preview("Modal with Image") {
    ZStack {
        Color.gray.opacity(0.8)
            .ignoresSafeArea()
        
        ProfileModalView()
            .padding(40)
    }
}

#Preview("Modal without Image") {
    ZStack {
        Color.gray.opacity(0.8)
            .ignoresSafeArea()
        
        ProfileModalView(imageName: nil)
            .padding(40)
    }
}
