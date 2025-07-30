//
//  FeatureThree.swift
//  SuccessQuotes
//
//  Created by Barbara on 14/07/2025.
//

import SwiftUI

struct FeatureThree: View {
    var onContinue: () -> Void
    
    // Animation state variables
    @State private var heartScale: CGFloat = 1.0
    @State private var heartColor: Color = .black
    @State private var searchScale: CGFloat = 1.0
    @State private var shareRotation: Double = 0.0
    
    var body: some View {
        ZStack {
            // 1. Black background
            Color.onboardbg.ignoresSafeArea()
            VStack (alignment: .leading) {
                VStack {
                    Spacer()
                VStack {
                    // Search pill (right)
                    HStack {
                        Spacer()
                        HStack {
                            Image("search.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("search")
                                .foregroundColor(.black)
                                .font(.custom("Helvetica Now Display", size: 14))
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .background(Color.white)
                        .cornerRadius(22)
                        .offset(x: -10, y: -30)
                        .scaleEffect(0.94 * searchScale)
                    }
                    
                    // Save pill (left)
                    HStack {
                        HStack (spacing: 4) {
                            Image(systemName: "heart.fill")
                                .foregroundColor(heartColor)
                                .font(.system(size: 19))
                                .scaleEffect(heartScale)
                            Text("save")
                                .foregroundColor(.black)
                                .font(.custom("Helvetica Now Display", size: 14))
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .background(Color.white)
                        .cornerRadius(22)
                        .offset(x: 10, y: -5)
                        .scaleEffect(0.95)
                        Spacer()
                    }
                    
                    // Share pill (center)
                    HStack {
                        Image("share")
                            .resizable()
                            .frame(width: 17, height: 18)
                            .foregroundColor(.black)
                            .rotationEffect(.degrees(shareRotation))
                        Text("share")
                            .foregroundColor(.black)
                            .font(.custom("Helvetica Now Display", size: 14))
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(Color.white)
                    .cornerRadius(22)
                    .offset(x: 0, y: 70)
                    .scaleEffect(0.95)
                }
                .padding(24)
                
                Spacer()
                
                
                // Page indicator
                HStack(spacing: 8) {
                    Circle().frame(width: 10, height: 10).foregroundColor(.gray.opacity(0.8))
                    Circle().frame(width: 10, height: 10).foregroundColor(.gray.opacity(0.8))
                    Capsule().frame(width: 30, height: 10).foregroundColor(.white)
                }
                .padding(.bottom, 32)
            }
                
            // 4. Text
            VStack(alignment: .leading, spacing: 0) {
                Text("Discover, Save, and Share ")
                    .foregroundColor(Color.yella)
                    .font(.custom("Helvetica Now Display Medium", size: 22)) +
                Text("quotes that")
                    .foregroundColor(.featurewhite)
                    .font(.custom("Helvetica Now Display Medium", size: 22)) +
                Text(" move you ")
                    .foregroundColor(.featurewhite)
                    .font(.custom("Helvetica Now Display Medium", size: 22)) +
                Text("+ more")
                    .foregroundColor(.featurewhite)
                    .font(.custom("Helvetica Now Display Medium", size: 22))
            }
            .padding(.horizontal, 22)

            // Arrow button
                HStack {
                    Spacer()
                    Button(action: { onContinue() }) {
                        HStack (spacing: 0) {
                            Text("Setup")
                                .foregroundColor(.white)
                                .font(.custom("Inter-Regular", size: 16))
                            Image("arrowright")
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 4))
    //                    .padding(.vertical, 16)
                        .background(Color.arrowgrey)
                        .cornerRadius(32)
                    }
                }
                .padding(.horizontal)
        }
        }
        .onAppear {
            // Start animations with delays
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // Heart animation - pop and turn red
                withAnimation(.easeInOut(duration: 0.3)) {
                    heartScale = 1.3
                    heartColor = .red
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        heartScale = 1.0
                    }
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                // Search animation - scale up then down
                withAnimation(.easeInOut(duration: 0.2)) {
                    searchScale = 1.1
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        searchScale = 1.0
                    }
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                // Share animation - wiggle
                withAnimation(.easeInOut(duration: 0.1)) {
                    shareRotation = 10
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        shareRotation = -10
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.easeInOut(duration: 0.1)) {
                            shareRotation = 0
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    FeatureThreePreviewWrapper()
}

struct FeatureThreePreviewWrapper: View {
    @State private var showNotificationsSetup = false

    var body: some View {
        if showNotificationsSetup {
            NotificationsSetup(onAllowed: {}, onDenied: {})
        } else {
            FeatureThree(onContinue: { showNotificationsSetup = true })
        }
    }
}
