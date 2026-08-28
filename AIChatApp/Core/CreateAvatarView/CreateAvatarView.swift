//
//  CreateAvatarView.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 7/3/26.
//

import SwiftUI

struct CreateAvatarView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AIManager.self) private var aiManager
    
    @State private var avatarName: String = ""
    @State private var generatedImage: UIImage?
    @State private var isGenerating: Bool = false
    @State private var isLoading: Bool = false
    @State private var characterOption: CharacterOption = .default
    @State private var characterAction: CharacterAction = .default
    @State private var characterLocation: CharacterLocation = .default
    
    var body: some View {
        NavigationStack {
            List {
                nameSection
                attributesSection
                generateImageSection
                saveSection
            }
            .navigationTitle("Create Avatar")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "xmark")
                        .foregroundStyle(.accent)
                        .anyButton(.press) {
                            dismiss()
                        }
                }
            }
        }
    }
    
    private var nameSection: some View {
        Section {
            TextField("Player 1", text: $avatarName)
        } header: {
            Text("Name Your Avatar*")
        }
    }
    
    private var attributesSection: some View {
        Section {
            Picker("is a...", selection: $characterOption) {
                ForEach(CharacterOption.allCases, id: \.self) { option in
                    Text(option.rawValue)
                        .tag(option)
                }
            }
            
            Picker("that is...", selection: $characterAction) {
                ForEach(CharacterAction.allCases, id: \.self) { option in
                    Text(option.rawValue)
                        .tag(option)
                }
            }
            
            Picker("in the...", selection: $characterLocation) {
                ForEach(CharacterLocation.allCases, id: \.self) { option in
                    Text(option.rawValue)
                        .tag(option)
                }
            }
        } header: {
            Text("Attributes")
        }
    }
    
    private var generateImageSection: some View {
        Section {
            HStack(alignment: .top) {
                ZStack {
                    Text("Generate image")
                        .foregroundStyle(.accent)
                        .underline()
                        .padding()
                        .anyButton(.plain) {
                            onGenerateImagePressed()
                        }
                        .opacity(isGenerating ? 0 : 1)
                        .disabled(avatarName.isEmpty || isGenerating)
                    
                    ProgressView()
                        .tint(.accent)
                        .opacity(isGenerating ? 1 : 0)
                }
                
                Circle()
                    .fill(.secondary.opacity(0.3))
                    .overlay {
                        if let image = generatedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                        }
                    }
                    .clipShape(Circle())
            }
            .removeListRowFormatting()
        }
    }
    
    private var saveSection: some View {
        Section {
            AsyncCallToActionButton(isLoading: isLoading) {
                onSavedPressed()
            }
            .disabled(generatedImage == nil)
            .opacity(generatedImage == nil ? 0.5 : 1)
            .removeListRowFormatting()
            .padding(.top, 24)
        }
    }
    
    private func onGenerateImagePressed() {
        isGenerating = true
        
        Task {
            do {
                let query = AvatarDescriptionHandler(
                    characterOption: characterOption,
                    characterAction: characterAction,
                    characterLocation: characterLocation)
                    .characterDescription
                generatedImage = try await aiManager.generateImage(from: query)
            } catch {
                print(error.localizedDescription)
            }
            isGenerating = false
        }
    }
    
    private func onSavedPressed() {
        isLoading = true
        Task {
            try? await Task.sleep(for: .seconds(3))
            generatedImage = UIImage(systemName: "figure")
            isLoading = false
            dismiss()
        }
    }
}

#Preview {
    CreateAvatarView()
        .environment(AIManager(service: MockAIService()))
}
