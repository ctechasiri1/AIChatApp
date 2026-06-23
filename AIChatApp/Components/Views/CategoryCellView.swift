//
//  CategoryCellView.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 6/23/26.
//

import SDWebImageSwiftUI
import SwiftUI

struct CategoryCellView: View {
    var title: String = "Alien"
    var imageName: String = Constants.randomImage
    var font: Font.TextStyle = .title3
    var cornderRadius: CGFloat = 16
    
    var body: some View {
        ImageLoaderView(urlString: imageName)
            .aspectRatio(1, contentMode: .fit)
            .overlay(alignment: .bottomLeading, content: {
                Text(title)
                    .foregroundStyle(.white)
                    .font(.system(font, weight: .semibold))
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .addingGradientBackgroundForText()
                
            })
            .clipShape(RoundedRectangle(cornerRadius: cornderRadius))
    }
}

#Preview {
    VStack {
        CategoryCellView()
            .frame(width: 150)
        
        CategoryCellView()
            .frame(width: 300)
        
    }
}
