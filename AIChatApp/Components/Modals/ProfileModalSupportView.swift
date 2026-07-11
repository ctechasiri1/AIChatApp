//
//  ModalSupportView.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 7/10/26.
//

import SwiftUI

struct ModalSupportView<Content: View>: View {
    
    @Binding var showProfileModal: Bool
    @ViewBuilder var content: Content
    
    var body: some View {
        ZStack {
            if showProfileModal {
                Color.black.opacity(0.6)
                    .ignoresSafeArea()
                    .transition(AnyTransition.opacity.animation(.smooth))
                    .onTapGesture {
                        showProfileModal = false
                    }
                    .zIndex(1)
                
                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    .zIndex(2)
            }
        }
        .zIndex(9999)
        .animation(.bouncy, value: showProfileModal)
    }
}

extension View {
    func showModal(for condition: Binding<Bool>, @ViewBuilder content: () -> some View) -> some View {
        self
            .ignoresSafeArea()
            .overlay {
                ModalSupportView(showProfileModal: condition) {
                    content()
                }
            }
    }
}

#Preview {
    @State @Previewable var showProfileModal: Bool = false
    
    Text("Tap Me")
        .onTapGesture {
            showProfileModal = true
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .showModal(for: $showProfileModal, content: {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 300, height: 400)
                .transition(.slide)
                .padding(60)
        })
}
