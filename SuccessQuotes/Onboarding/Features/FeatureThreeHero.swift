//
//  FeatureThreeHero.swift
//  SuccessQuotes
//
//  Created by Barbara on 26/07/2025.
//

import SwiftUI

struct FeatureThreeHero: View {
    // Animation state variables
    @State private var heartScale: CGFloat = 1.0
    @State private var heartColor: Color = .black
    @State private var searchScale: CGFloat = 1.0
    @State private var shareRotation: Double = 0.0
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack (alignment: .leading) {
                VStack {
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
                }
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
    FeatureThreeHero()
}
