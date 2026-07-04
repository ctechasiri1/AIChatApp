//
//  CreateAccountView.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 7/3/26.
//

import AuthenticationServices
import SwiftUI

struct CreateAccountView: View {
    
    var title: String = "Create Account?"
    var description: String = "Dont't lose your data! Connect to an SSO provider to save your account."

    var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(.largeTitle, weight: .semibold))
                
                Text(description)
                    .font(.system(.body))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            SignInWithAppleButtonView(
                type: .signIn,
                style: .black, cornerRadius: 30)
            .frame(height: 50)
            
            Spacer()
        }
        .padding(16)
        .padding(.top, 40)
    }
}

#Preview {
    CreateAccountView()
}
