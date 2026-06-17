//
//  OnboardingColorView.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 6/17/26.
//

import SwiftUI

struct OnboardingColorView: View {
    @State var selectedColor: Color?
    var profileColors: [Color] = [.red, .green, .orange, .blue, .mint, .purple, .cyan, .teal, .indigo]
    
    var body: some View {
        ScrollView {
            colorGrid
                .padding(.horizontal, 24)
        }
        .safeAreaInset(edge: .bottom, alignment: .center, spacing: 16, content: {
            ZStack {
                if let selectedColor {
                    ctaButton
                        .transition(AnyTransition.move(edge: .bottom))
                }
            }
            .padding(24)
            .background(Color(uiColor: .systemBackground))
        })
        .animation(.smooth, value: selectedColor)
    }
    
    private var colorGrid: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 3),
            alignment: .center,
            spacing: 16,
            pinnedViews: [.sectionHeaders],
            content: {
                Section(content: {
                    ForEach(profileColors, id: \.self) { color in
                        Circle()
                            .fill(.accent)
                            .overlay {
                                color
                                    .clipShape(Circle())
                                    .padding(selectedColor == color ? 6 : 0)
                            }
                            .onTapGesture {
                                selectedColor = color
                            }
                    }
                }, header: {
                    Text("Select a profile color")
                        .font(.system(.headline))
                        .frame(maxWidth: .infinity)
                })
            }
        )
    }
    
    private var ctaButton: some View {
        NavigationLink {
            OnboardingCompletedView()
        } label: {
            Text("Continue")
                .callToActionButtion()
        }
    }
}

#Preview {
    NavigationStack {
        OnboardingColorView()
    }
}
