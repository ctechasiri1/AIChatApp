//
//  View+EXT.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 6/10/26.
//

import SwiftUI

extension View {
    func callToActionButtion() -> some View {
        self
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(.accent, in: .rect(cornerRadius: 16))
    }
    
    func blueBadge() -> some View {
        self
            .foregroundStyle(Color.white)
            .font(.system(.caption, weight: .bold))
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
    
    func tappableBackground() -> some View {
        background(Color.black.opacity(0.001))
    }
    
    func removeListRowFormatting() -> some View {
        self
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowBackground(Color.clear)
    }
    
    func addingGradientBackgroundForText() -> some View {
        background(
            LinearGradient(
                colors: [
                    Color.black.opacity(0.0),
                    Color.black.opacity(0.3),
                    Color.black.opacity(0.4)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
    
    /// this should be the last option for anything, there probably is a better way to do this
    @ViewBuilder
    func ifForceTransitionAnimation(for condition: Bool, content: (Self) -> some View) -> some View {
        if condition {
            content(self)
        } else {
            self
        }
    }
}
