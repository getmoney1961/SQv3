//
//  WdigetSetup.swift
//  SuccessQuotes
//
//  Created by Barbara on 14/07/2025.
//

import SwiftUI

struct WidgetSetup: View {
    var onContinue: () -> Void
    var body: some View {
        ZStack {
            Color.onboardbg.ignoresSafeArea()
            ZStack {
                ZStack {
                    // Phone illustration placeholder
                    Image("widget") // Replace with your custom image if available
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 375)
//                        .padding(.top, 16)
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black, Color.black.opacity(0.01)]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black, Color.black.opacity(0.05)]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black, Color.black.opacity(0.1)]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    .ignoresSafeArea()
                }
//                .frame(height: 375) // Add this line to constrain the ZStack height

            VStack(spacing: 24) {
                                Spacer().frame(height: 40)
                                VStack(spacing: 20) {
                                    // Title
                                    Text("Add a widget to your home screen")
                                        .font(.custom("EditorialNew-Regular", size: 22)) // Use your custom serif font if available
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 24)
                
                                    // Subtitle
                                    Text("Our widgets are designed to inspire, motivate and help you have a great day")
                                        .font(.custom("Helvetica Now Display", size: 14))
                                        .foregroundColor(Color(white: 0.85))
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 32)
                                }
                                Spacer()

                
                VStack {
                    HStack(alignment: .top, spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 22, height: 22)
                            Text("1")
                                .font(.custom("Helvetica Now Display", size: 13))
                                .foregroundColor(.black)
                        }
                        Text("To set up, touch and hold the background of your phone’s Home Screen until the apps jiggle.")
                            .foregroundColor(.onboardgrey)
                            .font(.custom("Helvetica Now Display", size: 14))
                            .multilineTextAlignment(.center)
                    }
                    //                    .padding(.horizontal, 40)
                    
                    HStack(alignment: .top, spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 22, height: 22)
                            Text("2")
                                .font(.custom("Helvetica Now Display", size: 13))
                                .foregroundColor(.black)
                        }
                        Text("Then tap the “+” or “edit” button in the upper-left corner to add the widget.")
                            .foregroundColor(.onboardgrey)
                            .font(.custom("Helvetica Now Display", size: 14))
                            .multilineTextAlignment(.center)
                    }
                    //                    .padding(.horizontal, 40)
                }
                .padding(.horizontal, 28)
                
                
                // Button
                Button(action: {
                    onContinue()
                }) {
                    Text("I'm all set!")
                        .font(.custom("Inter-Medium", size: 14))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, minHeight: 56)
                        .background(Color.white)
                        .cornerRadius(40)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 24)
            }
        }
        }
    }
}

#Preview {
    WidgetSetupPreviewWrapper()
}

struct WidgetSetupPreviewWrapper: View {
    @State private var showPaymentOnboard = false

    var body: some View {
        if showPaymentOnboard {
            PaymentOnboard(onContinue: {})
        } else {
            WidgetSetup(onContinue: {showPaymentOnboard = true })
        }
    }
}
