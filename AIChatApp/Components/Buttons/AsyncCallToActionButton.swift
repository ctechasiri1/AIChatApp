//
//  AsyncCallToActionButton.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 7/3/26.
//

import SwiftUI

struct AsyncCallToActionButton: View {
    
    var title: String = "Save"
    var isLoading: Bool = false
    var action: () -> Void
    
    var body: some View {
        ZStack {
            if isLoading {
                ProgressView()
                    .tint(.white)
            } else {
                Text(title)
            }
        }
        .callToActionButtion()
        .anyButton(.press) {
            action()
        }
        .disabled(isLoading)
    }
}

private struct PreviewView: View {
    
    @State private var isLoading: Bool = false
    
    var body: some View {
        AsyncCallToActionButton(isLoading: isLoading) {
            isLoading = true
            Task {
                try? await Task.sleep(for: .seconds(3))
                isLoading = false
            }
        }
    }
}

#Preview {
    PreviewView()
        .padding()
}
