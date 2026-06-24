//
//  ButtonViewModifiers.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 6/23/26.
//

import SwiftUI

struct HighlightButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .overlay {
                configuration.isPressed ? Color.accent.opacity(0.4) : Color.accent.opacity(0.0)
            }
            .animation(.smooth, value: configuration.isPressed)
    }
}

struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.smooth, value: configuration.isPressed)
    }
}

enum ButtonOption {
    case highlight, press, plain
}

extension View {
    @ViewBuilder
    func anyButton(_ option: ButtonOption = .plain, action: @escaping () -> Void) -> some View {
        switch option {
        case .highlight:
            self.highlightButton(action: action)
        case .press:
            self.pressableButton(action: action)
        case .plain:
            self.plainButton(action: action)
        }
    }
    
    private func highlightButton(action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            self
        }
        .buttonStyle(HighlightButtonStyle())
    }
    
    private func pressableButton(action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            self
        }
        .buttonStyle(PressableButtonStyle())
    }
    
    private func plainButton(action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            self
        }
        .buttonStyle(PlainButtonStyle())
    }
}
                                
#Preview {
    VStack {
        Text("Hello, world!")
            .padding()
            .frame(maxWidth: .infinity)
            .anyButton(.highlight) {
                
            }
            .padding()
        
        Text("Hello, world!")
            .callToActionButtion()
            .anyButton(.press) {
                
            }
            .padding()
        
        Text("Hello, world!")
            .padding()
            .frame(maxWidth: .infinity)
            .anyButton {
                
            }
            .padding()
    }
}
