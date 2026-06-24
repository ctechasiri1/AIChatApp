//
//  CustomListCellView.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 6/23/26.
//

import SwiftUI

struct CustomListCellView: View {
    
    var imageName: String? = Constants.randomImage
    var title: String? = "Alpha"
    var description: String? = "An alien taht is smiling in the park"
    
    var body: some View {
        HStack(spacing: 8) {
            Group {
                if let imageName {
                    ImageLoaderView(urlString: imageName)
                } else {
                    Rectangle()
                        .fill(.secondary.opacity(0.5))
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .frame(height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 16))
                
            VStack(alignment: .leading, spacing: 4) {
                if let title {
                    Text(title)
                        .font(.system(.headline))
                }
                    
                if let description {
                    Text(description)
                        .font(.system(.subheadline))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .padding(.vertical, 4)
        .background(Color(uiColor: .systemBackground))
    }
}

#Preview {
    ZStack {
        Color.gray.ignoresSafeArea()
        
        CustomListCellView(imageName: Constants.randomImage, title: "Alpha", description: "An alien that is smiling in the park.")
    }
}
