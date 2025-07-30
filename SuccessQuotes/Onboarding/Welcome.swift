//
//  Welcome.swift
//  SuccessQuotes
//
//  Created by Barbara on 13/07/2025.
//

import SwiftUI

struct Welcome: View {
    @StateObject private var signInViewModel = AppleSignInViewModel()
    var onContinue: () -> Void
    
    var body: some View {
        ZStack {
            Color.onboardbg.ignoresSafeArea()
            VStack() {
                Spacer().frame(height: 40)
                Text("Welcome to Success Quotes")
                    .font(.custom("EditorialNew-Regular", size: 24))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 40)
                
                                Spacer()
                
                VStack (spacing: 16) {
                    // Collage of famous people
                    FamousPeopleCollage()
                        .padding(.vertical, 10)
                    
                    Text("Your Journey To A Success Life Begins Here")
                        .font(.custom("Helvetica Now Display", size: 12))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
//                        .padding(.bottom, 10)
                    
                }
                
                                Spacer()
                VStack (spacing: 32) {
                    // Continue with Apple button
                    AppleSignInButton {
//                        signInViewModel.startSignInWithAppleFlow()
                        onContinue()
                    }
                    .frame(height: 56)
                    .padding(.horizontal, 16)
            
                    .onReceive(signInViewModel.$userIdentifier) { userId in
                        if let userId = userId {
                            // Handle successful sign in (e.g., navigate to main app)
                        }
                    }
                    .onReceive(signInViewModel.$error) { error in
                        if let error = error {
                            // Show error alert
                        }
                    }
                    
 
                    
                    // Terms and Privacy
                    TermsAndPrivacyText()
                }
//                Spacer()
            }
        }
    }
}

struct FamousPeopleCollage: View {
    var body: some View {
        VStack(spacing: -20) {
            HStack(spacing: -20) {
                Image("art2")
                    .resizable()
                    .frame(width: 267,height: 305)

            }
        }
    }
}
// MARK: - FamousPeopleCollage - add links
struct TermsAndPrivacyText: View {
    var body: some View {
        // Build the attributed string
        let termsURL = URL(string: "https://yourterms.url")!
        let privacyURL = URL(string: "https://yourprivacy.url")!
        var attributed = AttributedString("by tapping “Continue with Apple” you agree to the Terms of Service and Privacy Policy")
        if let range = attributed.range(of: "Terms of Service") {
            attributed[range].link = termsURL
            attributed[range].underlineStyle = .single
            attributed[range].foregroundColor = .gray
        }
        if let range = attributed.range(of: "Privacy Policy") {
            attributed[range].link = privacyURL
            attributed[range].underlineStyle = .single
            attributed[range].foregroundColor = .gray
        }
        return Text(attributed)
            .font(.custom("Inter-Regular", size: 12))
            .foregroundColor(.gray)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
            .fixedSize(horizontal: false, vertical: true)
    }
}

// MARK: - SignInWithAppleButton - configure
import AuthenticationServices
struct AppleSignInButton: View {
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "applelogo")
                    .font(.title2)
                Text("Continue with Apple")
                    .font(.custom("Inter-Regular", size: 16))
                    .padding(.vertical, 64)
            }
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, minHeight: 56)
            .background(Color.white)
            .cornerRadius(28)
        }
    }
}


#Preview {
    WelcomePreviewWrapper()
}

struct WelcomePreviewWrapper: View {
    @State private var showFeatureOne = false

    var body: some View {
        if showFeatureOne {
            FeatureOne(onContinue: {})
        } else {
            Welcome(onContinue: { showFeatureOne = true })
        }
    }
}
