//
//  Intro.swift
//  SuccessQuotes
//
//  Created by Barbara on 13/07/2025.
//

import SwiftUI


struct Intro: View {
        @State private var showLine1 = false
        @State private var showLine2 = false
        @State private var showLine3 = false
        @State private var showImage = true
    @State private var showWelcome = false
    var onContinue: () -> Void

        var body: some View {
            ZStack {
                Color.onboardbg.ignoresSafeArea()
                if !showWelcome {
                    
                    VStack(spacing: 24) {
                        // Line 1
                        Group {
                            (
                                Text("Adopt the mindset of the ")
                                    .foregroundColor(.introtext)
                                    .font(.custom("Helvetica Now Display", size: 16))
                                +
                                Text("greats.")
                                    .foregroundColor(.white)
                                    .font(.custom("Helvetica Now Display Bold", size: 16))
                            )
                        }
                        .opacity(showLine1 ? 1 : 0)
                        // Line 2
                        Group {
                            (
                                Text("Gain ")
                                    .foregroundColor(.introtext)
                                    .font(.custom("Helvetica Now Display", size: 16))
                                +
                                Text("wisdom")
                                    .foregroundColor(.white)
                                    .font(.custom("Helvetica Now Display Bold", size: 16))
                                +
                                Text(" needed for success.")
                                    .foregroundColor(.introtext)
                                    .font(.custom("Helvetica Now Display", size: 16))
                                
                            )
                        }
                        .opacity(showLine2 ? 1 : 0)
                        // Line 3
                        Group {
                            (
                                Text("Develop the mindset necessary to ")
                                    .foregroundColor(.introtext)
                                    .font(.custom("Helvetica Now Display", size: 16))
                                
                                +
                                Text("achieve\nyour goals.")
                                    .foregroundColor(.white)
                                    .font(.custom("Helvetica Now Display Bold", size: 16))
                            )
                        }
                        .opacity(showLine3 ? 1 : 0)
                    }
                    .multilineTextAlignment(.center)
                    .font(.system(size: 16))
                    
                    if showWelcome {
                        Welcome(onContinue: onContinue)
//                            .transition(.opacity)
                            .zIndex(1)
                            .ignoresSafeArea()
                    }
                    
                    // MARK: - SignInWithAppleButton - configure
                    //Splash Screen
                    Image("launchscreenalt")
                        .resizable()
                        .ignoresSafeArea()
                        .opacity(showImage ? 1 : 0)
                    
                    // Move onAppear to VStack so it doesn't trigger multiple times
                        .onAppear {
                            // 1. Wait 2 seconds, then fade out the image over 2 seconds
                            // MARK: - SignInWithAppleButton - configure
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                 withAnimation(.easeOut(duration: 2.0)) {
                                     showImage = false
                                 }
                             }
                            // 2. Fade in the text after the image fades out
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                withAnimation(.easeIn(duration: 1.5)) {
                                    showLine1 = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                    withAnimation(.easeIn(duration: 3.0 //or2.5 //
                                                         )) {
                                        showLine2 = true
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.2) {
                                        withAnimation(.easeIn(duration: 3.0)) {
                                            showLine3 = true
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0)
                                        {
                                            onContinue()
                                        }
                                    }
                                }
                            }
                        }
                }
            }
//            // Present Welcome as a full screen cover
//            .fullScreenCover(isPresented: $showWelcome) {
//                Welcome(onContinue: onContinue)
//            }
        }
    }

#Preview {
    IntroPreviewWrapper()
}

struct IntroPreviewWrapper: View {
    @State private var showWelcome = false

    var body: some View {
        if showWelcome {
            Welcome(onContinue: {})
        } else {
            Intro(onContinue: { showWelcome = true })
        }
    }
}
