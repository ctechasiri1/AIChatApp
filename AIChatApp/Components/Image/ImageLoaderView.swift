//
//  ImageLoaderView.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 6/17/26.
//

import SDWebImageSwiftUI
import SwiftUI

struct ImageLoaderView: View {
    var imageString: String = Constants.randomImage
    var resizingMode: ContentMode = .fill
    
    var body: some View {
        Rectangle()
            .overlay {
                WebImage(url: URL(string: imageString))
                    .resizable()
                    .indicator(.activity)
                    .aspectRatio(contentMode: resizingMode)
            }
            .clipped()
    }
}

#Preview {
    ImageLoaderView()
        .frame(width: 100, height: 200)
}
