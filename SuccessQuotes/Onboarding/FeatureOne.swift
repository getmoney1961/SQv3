//
//  FeatureOne.swift
//  SuccessQuotes
//
//  Created by Barbara on 13/07/2025.
//

import SwiftUI

struct FeatureQuoteCard: View {
    let quote: String
    let author: String
    let rotation: Double
    let width: CGFloat
    let offset: CGSize
    let scale: CGFloat // 1. Add this line
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(quote)
                .font(.custom("NewYork-Regular", size: 13))
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
            Text(author)
                .font(.custom("NewYork-Regular", size: 11))
                .foregroundColor(.gray)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .frame(width: width, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(1))
                .shadow(color: Color.black.opacity(0.07), radius: 10, x: 0, y: 1)
        )
        .rotationEffect(.degrees(rotation))
        .offset(offset)
        .scaleEffect(scale) // 3. Add this line
    }
}

struct FeatureOne: View {
    var onContinue: () -> Void
    @State private var cardsFallen: [Bool] = Array(repeating: false, count: 9)
    
    var body: some View {
        ZStack {
            Color.onboardbg.ignoresSafeArea()
            VStack (alignment: .leading) {
                VStack {
                    Spacer()
                    ZStack {
                        // 2. Pass decreasing scale values (1.0, 0.95, 0.92, etc.)
                        FeatureQuoteCard(
                            quote: "The best way to predict the future is to create it.",
                            author: "Peter Drucker",
                            rotation: 0,
                            width: 320,
                            offset: CGSize(width: 0, height: cardsFallen[0] ? -205 : -600),
                            scale: 1.0
                        )
                        FeatureQuoteCard(
                            quote: "One must not lose desires. They are mighty stimulants to creativeness, to love and to long life.",
                            author: "Alexander Bogomoletz",
                            rotation: 6,
                            width: 300,
                            offset: CGSize(width: 100, height: cardsFallen[1] ? -190 : -600),
                            scale: 0.75
                        )
                        FeatureQuoteCard(
                            quote: "Life is either a daring adventure or nothing at all.",
                            author: "Helen Keller",
                            rotation: 13,
                            width: 290,
                            offset: CGSize(width: -155, height: cardsFallen[2] ? -185 : -600),
                            scale: 0.6
                        )
                        FeatureQuoteCard(
                            quote: "The only limit to our realization of tomorrow will be our doubts of today.",
                            author: "Franklin D. Roosevelt",
                            rotation: -15,
                            width: 300,
                            offset: CGSize(width: -80, height: cardsFallen[3] ? -45 : -600),
                            scale: 0.80
                        )
                        FeatureQuoteCard(
                            quote: "Imagination is more important than knowledge.",
                            author: "Albert Einstein",
                            rotation: 0,
                            width: 260,
                            offset: CGSize(width: 170, height: cardsFallen[4] ? -70 : -600),
                            scale: 0.6
                        )
                        FeatureQuoteCard(
                            quote: "You can't use up creativity. The more you use, the more you have.",
                            author: "Maya Angelou",
                            rotation: 0,
                            width: 300,
                            offset: CGSize(width: 30, height: cardsFallen[5] ? 60 : -600),
                            scale: 0.65
                        )
                        FeatureQuoteCard(
                            quote: "In the middle of difficulty lies opportunity.",
                            author: "Albert Einstein",
                            rotation: 8,
                            width: 280,
                            offset: CGSize(width: -50, height: cardsFallen[6] ? 170 : -600),
                            scale: 0.65
                        )
                        FeatureQuoteCard(
                            quote: "Creativity is intelligence having fun.",
                            author: "Albert Einstein",
                            rotation: 0,
                            width: 300,
                            offset: CGSize(width: 150, height: cardsFallen[7] ? 280 : -600),
                            scale: 0.65
                        )
                        FeatureQuoteCard(
                            quote: "The only way to do great work is to love what you do.",
                            author: "Steve Jobs",
                            rotation: 0,
                            width: 300,
                            offset: CGSize(width: -100, height: cardsFallen[8] ? 370 : -600),

                            scale: 0.65
                        )
                    }
                    .scaleEffect(0.85) // 3. Add this line
                    .onAppear {
                        for i in 0..<cardsFallen.count {
                            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.01) {
                                withAnimation(.easeOut(duration: 1.2)) {
                                    cardsFallen[i] = true
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Page indicator
                    HStack(spacing: 8) {
                        Capsule().frame(width: 30, height: 10).foregroundColor(.white)
                        Circle().frame(width: 10, height: 10).foregroundColor(.gray.opacity(0.8))
                        Circle().frame(width: 10, height: 10).foregroundColor(.gray.opacity(0.8))
                    }
                    .padding(.bottom, 32)
                    
                }
                .frame(maxWidth: .infinity)
                
//                Spacer()

                // Bottom text
                VStack(alignment: .leading, spacing: 0) {
                    Text("The world’s largest library ")
                        .foregroundColor(Color.yella)
                        .font(.custom("Helvetica Now Display Medium", size: 22))
                    + Text("on success always in your pocket")
                        .foregroundColor(Color.featurewhite)
                        .font(.custom("Helvetica Now Display Medium", size: 22))
                }
                .padding(.horizontal, 22)
                // Arrow button
                    HStack {
                        Spacer()
                        Button(action: {
                            onContinue()
                        }) {
                            Image("arrow")
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                    }
                    .padding(.horizontal)
            }
        }
    }
}



#Preview {
    FeatureOnePreviewWrapper()
}

struct FeatureOnePreviewWrapper: View {
    @State private var showFeatureTwo = false

    var body: some View {
        if showFeatureTwo {
            FeatureTwo(onContinue: {})
        } else {
            FeatureOne(onContinue: { showFeatureTwo = true })
        }
    }
}
