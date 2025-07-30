//
//  SwiftUIView.swift
//  SuccessQuotes
//
//  Created by Barbara on 26/07/2025.
//

import SwiftUI

struct FeatureTwoHero: View {
    @State private var showContextTryMe = false
    @State private var wiggleAnimation = false
    
    var body: some View {
        
        VStack (alignment: .leading) {
            Spacer()                    .frame(height: showContextTryMe ? 60 : 160) // Changed from 160 to conditional height
            
            
            VStack {
                // Quote Card
                ZStack(alignment: .bottomTrailing) {
                    VStack(alignment: .leading, spacing: 10) {
                        Image("quotemarks")
                        Text("I have walked that long road to freedom. I have tried not to falter; I have made missteps along the way. But I have discovered the secret that after climbing a great hill, one only finds that there are many more hills to climb.")
                            .font(.custom("ACaslonPro-Regular", size: 14))
                            .foregroundColor(.white)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.center)
                        HStack {
                            Spacer()
                            Text("- Nelson Mandela")
                                .font(.custom("ACaslonPro-SemiBold", size: 14))
                                .foregroundColor(.paymentgrey)
                            Spacer()
                        }
                        .padding(.bottom, -10)
                        HStack {
                            Spacer()
                            Image("quotemarksright")
                        }
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 35)
                            .fill(Color.black.opacity(0.7))
                            .overlay(
                                RoundedRectangle(cornerRadius: 35)
                                    .stroke(Color.featuregrey, lineWidth: 1)
                            )
                    )
                    // Try Me Button
                    HStack {
                        if showContextTryMe {
                            Text("close")
                                .font(.custom("Helvetica Now Display", size: 14))
                                .foregroundColor(.white)
                                .padding(.horizontal, 18)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 22)
                                        .fill(Color.featuregrey)
                                )
                        } else {
                            HStack (spacing: 4) {
                                Image(systemName: "lightbulb.max.fill")
                                Text("try me")
                                    .font(.custom("Helvetica Now Display", size: 13))
                            }
                            .foregroundColor(.black)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(Color.buttonyellow)
                            )
                        }
                    }
                    .onTapGesture {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.5)) {
                            showContextTryMe.toggle()
                        }
                    }
                    .offset(x: 9, y: 5)
                    .rotationEffect(.degrees(wiggleAnimation ? -20 : 0))
                    .animation(.easeInOut(duration: 0.1).repeatCount(7, autoreverses: true), value: wiggleAnimation)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                            wiggleAnimation.toggle()
                            // Reset the animation state after it completes
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                wiggleAnimation = false
                            }
                        }
                    }
                }
                .padding(.horizontal, 28)
                //                .padding(.bottom, 60)
                
                Spacer()
                
                ScrollView {
                    VStack {
                        // Animated reveal of image
                        Image("contexttryme")
                            .resizable()
                            .scaledToFit()
                            .padding()
                        //                            .frame(height: 650)
                            .background(
                                RoundedRectangle(cornerRadius: 35)
                                    .fill(Color.black.opacity(0.7))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 35)
                                            .stroke(Color.featuregrey, lineWidth: 2)
                                    )
                            )
                            .padding(24)
                            .offset(y: showContextTryMe ? 0 : -200)
                            .opacity(showContextTryMe ? 1 : 0)
                            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: showContextTryMe)
                    }
                }    }
        }
    }
}

#Preview {
    FeatureTwoHero()
}
