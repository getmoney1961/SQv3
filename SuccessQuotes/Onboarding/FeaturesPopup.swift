//
//  FeaturesPopup.swift
//  SuccessQuotes
//
//  Created by Barbara on 21/07/2025.
//

import SwiftUI

struct Feature: Identifiable {
    let id = UUID()
    let icon: String         // Name of the icon (asset or SF Symbol)
    let isAssetImage: Bool   // true = asset, false = SF Symbol
    let title: String
    let subtitle: String
}

struct FeaturesPopup: View {
    @Environment(\.presentationMode) var presentationMode

    let features: [Feature] = [
        Feature(icon: "context", isAssetImage: true, title: "Context", subtitle: "Explore deeper meaning behind quotes, add depth instead of just flashy words"),
        Feature(icon: "unlock", isAssetImage: true, title: "Full access to the world’s biggest library on success", subtitle: "Over 1000+ wisdom from the worlds most successful people"),
        Feature(icon: "featuresearch", isAssetImage: true, title: "Quick search through quotes, authors and topics", subtitle: "Wisdom you won’t find anywhere else"),
        Feature(icon: "wisdom", isAssetImage: true, title: "Wisdom you won't find anywhere", subtitle: "Exclusive quotes"),
        Feature(icon: "featurebell", isAssetImage: true, title: "Set notifications for daily motivation", subtitle: "Inspiration at your fingertips"),
        Feature(icon: "featureshare", isAssetImage: true, title: "Share and save your favourite quotes easily", subtitle: "Connect with a community of quote enthusiasts"),
        Feature(icon: "bio2", isAssetImage: true, title: "Author Bios", subtitle: "Expand your perspective with every quote"),
        Feature(icon: "pip", isAssetImage: true, title: "Widgets", subtitle: "Find the perfect words for any occasion")
    ]

    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Background
            RoundedRectangle(cornerRadius: 40)
                .background(
                    Color.black
                        .clipShape(RoundedRectangle(cornerRadius: 40))
                )
                .edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading, spacing: 24) {
                Spacer().frame(height: 32)
                ForEach(features) { feature in
                    HStack(alignment: .center, spacing: 16) {
                        if feature.isAssetImage {
                            Image(feature.icon)
                                .resizable()
                                .foregroundColor(.featureicon)
                                .frame(width: 28, height: 28)
                                .frame(width: 16)
                        } else {
                            Image(systemName: feature.icon)
                                .foregroundColor(.white)
                                .font(.system(size: 28))
                                .frame(width: 32)
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text(feature.title)
                                .foregroundColor(.white)
                                .font(.custom("Inter-Regular", size: 16))
                            if !feature.subtitle.isEmpty {
                                Text(feature.subtitle)
                                    .foregroundColor(.paymentgrey)
                                    .font(.custom("Inter-Regular", size: 12))
                            }
                        }
                    }
                }
                
                HStack {
                    Image("checkcircle")
                        .resizable()
                        .frame(width: 22, height: 22)
                    Text("And all Future Pro Features")
                        .foregroundStyle(.white)
                        .font(.custom("Inter-Regular", size: 16))

                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("Coming soon...")
                        .foregroundColor(.white)
                        .font(.custom("Inter-Regular", size: 16))
                    Text("Customisable Sharing, Categories, Lock screen Widgets, Add Your Own Quotes, and more.")
                        .foregroundColor(.paymentgrey)
                        .font(.custom("Inter-Regular", size: 12))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.bottom, 32)
            }
            .padding(.horizontal, 32)
            // Close button
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image("close")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .padding(20)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    FeaturesPopup()
}
