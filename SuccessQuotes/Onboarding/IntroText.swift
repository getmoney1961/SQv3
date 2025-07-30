//
//  IntroText.swift
//  SuccessQuotes
//
//  Created by Barbara on 15/07/2025.
//

//
//  IntroText.swift
//  SuccessQuotes
//
//  Created by Barbara on 15/07/2025.
//

import SwiftUI

struct IntroText: View {
            @State private var currentPage = 0
            var onContinue: () -> Void
            
            var body: some View {
                ZStack {
                    Color.black.ignoresSafeArea()
                    
                    VStack {
                        ZStack (alignment: .bottomTrailing) {
                            
                            // Page indicator
                            HStack(spacing: 8) {
                                // Page 1
                                if currentPage == 0 {
                                    Capsule().frame(width: 30, height: 10).foregroundColor(.white)
                                } else {
                                    Circle().frame(width: 10, height: 10).foregroundColor(.white)
                                }
                                
                                // Page 2
                                if currentPage == 1 {
                                    Capsule().frame(width: 30, height: 10).foregroundColor(.white)
                                } else if currentPage > 1 {
                                    Circle().frame(width: 10, height: 10).foregroundColor(.white)
                                } else {
                                    Circle().frame(width: 10, height: 10).foregroundColor(.gray.opacity(0.8))
                                }
                                
                                // Page 3
                                if currentPage == 2 {
                                    Capsule().frame(width: 30, height: 10).foregroundColor(.white)
                                } else if currentPage > 2 {
                                    Circle().frame(width: 10, height: 10).foregroundColor(.white)
                                } else {
                                    Circle().frame(width: 10, height: 10).foregroundColor(.gray.opacity(0.8))
                                }
                            }
                            .padding(.bottom, 20)
                            .frame(maxWidth: .infinity, maxHeight: 200) // Adjust this height as needed
                            .background(.black)
                            
                            VStack(spacing: 0) {
                                // Main content area (quotes carousel)
                                TabView(selection: $currentPage) {
                                    // Tab 1
                                    VStack {
                                        FeatureOneHero()
                                            .offset(x: 0, y: 225)
                                        Spacer()
                                        FeatureOneText()
                                    }
                                    .tag(0)
                                    
                                    // Tab 2
                                    VStack {
                                        FeatureTwoHero()
                                        FeatureTwoText()
                                    }
                                    .tag(1)
                                    
                                    // Tab 3
                                    VStack {
                                        FeatureThreeHero()
                                        FeatureThreeText()
                                    }
                                    .tag(2)
                                }
                                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                            }



                        }
                        Spacer()
                        
                        
                        
                        // Arrow/Setup button
                        HStack {
                            Spacer()
                            Button(action: {
                                if currentPage < 2 {
                                    // Move to next page
                                    withAnimation {
                                        currentPage += 1
                                    }
                                } else {
                                    // On last page, call onContinue
                                    onContinue()
                                }
                            }) {
                                if currentPage < 2 {
                                    // Arrow button for first two pages
                                    Image("arrow")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                } else {
                                    // Setup button for last page
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
                                                .background(Color.arrowgrey)
                                                .cornerRadius(32)
                                            }
                                        }
                                }
                            }
                        }
                        .padding(.horizontal)

                    }
                }
            }
        }


#Preview {
    IntroText(onContinue: {})
}
