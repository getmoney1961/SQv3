//
//  PaymentTest.swift
//  SuccessQuotes
//
//  Created by Barbara on 23/01/2025.
//

import SwiftUI

struct PaymentTest: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedPlan: String = "Yearly"  // Set default selection to Yearly

    
    var body: some View {
        ZStack {
//            Color.blue.opacity(0.05).ignoresSafeArea()
            VStack {

                // Header
                Text("Invest in your mindset")
                    .font(.custom("EditorialNew-Regular", size: 28))
                    .multilineTextAlignment(.center)
                    .padding(.top, 32)
//                    .padding(.bottom, 16)
                
                ScrollView (showsIndicators: false) {
                    
                    FeatureComparisonView()
                        .padding(.horizontal)
                    VStack {
                        // Features List
                        VStack(alignment: .leading, spacing: 16) {
                            //                            ForEach(Features.all) { feature in
                            //                                HStack(spacing: 12) {
                            //                                    Image(systemName: feature.icon)
                            //                                        .foregroundColor(.green)
                            //                                        .font(.system(size: 24))
                            ////                                        .frame(width: 24) // Fixed width for alignment
                            //                                    Text(feature.text)
                            //                                        .font(.system(size: 14))
                            //                                        .lineLimit(nil)
                            //                                        .fixedSize(horizontal: false, vertical: true)
                            //                                }
                            //                                Divider()
                            //                            }
                        }
                        //                                                .padding(.horizontal)
                        
                    }
                    //                    .padding(.vertical)
                    //                    .padding(.horizontal, 16)
                    //                .background(.gray.opacity(0.1))
                    .cornerRadius(24)
                    //                .overlay(
                    //                    RoundedRectangle(cornerRadius: 24)
                    //                        .stroke(.gray.opacity(0.3), lineWidth: 2)
                    //                )
                    //                    .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 16))
                    
                }
                
                    VStack {
                        VStack(spacing: 0) {
                            
                            // Subscription Plans
                            VStack(spacing: 0) {
                                SubPlan(
                                    title: "Saver plan",
                                    price: "$4.99",
                                    period: "per month",
                                    features: ["Access to all pro features, pay monthly"],
                                    isSelected: selectedPlan == "Monthly",
                                    onSelect: { selectedPlan = "Monthly" },
                                    subtitle: "Only $4.99/month, billed monthly, cancel anytime"
                                )
                                
                                SubPlan(
                                    title: "Yearly plan",
                                    price: "$19.99",
                                    period: "per year",
                                    features: ["Access to all pro features + a year's worth of success wisdom in your pocket"],
                                    isFeatured: true,
                                    isSelected: selectedPlan == "Yearly",
                                    onSelect: { selectedPlan = "Yearly" },
                                    subtitle: "Only $1.66/month, billed annually, cancel anytime"
                                )
                                
                                SubPlan(
                                    title: "Lifetime Access",
                                    price: "$79.99",
                                    period: "forever",
                                    features: ["All pro features (incl. future pro features)", "One time payment, never pay again"],
                                    isFeatured: true,
                                    isSelected: selectedPlan == "Lifetime",
                                    onSelect: { selectedPlan = "Lifetime" },
                                    subtitle: "Pay once, keep forever"
                                )
                            }
                                                .padding(.horizontal)
                        }
//                        .padding()
                    }
                    
                    VStack {
                        // Main Subscribe Button
                        Button(action: {
                            // Add subscription logic here
                        }) {
                            Text("Continue")
                                .padding()
                                .foregroundStyle(selectedPlan.isEmpty ? .gray : .white)
                                .frame(maxWidth: .infinity, maxHeight: 48)
                                .background(selectedPlan.isEmpty ? .gray.opacity(0.1) : .black)
                                .cornerRadius(16)
                        }
                        .disabled(selectedPlan.isEmpty)
                        .padding()
                        
                        Text("Plan renews automatically. Cancel anytime before each renewal date. Already a subscriber? Restore Purchase")
                            .font(.system(size: 12))
                            .padding(.horizontal)
                        
                        Button("Continue with limited access") {
                            dismiss()
                        }
                        .font(.system(size: 12))
                        .foregroundColor(.gray.opacity(0.5))
                        .padding(.top, 2)
                        //                    // Continue with free version button
                        //                    Button("Continue with Free Version") {
                        //                        dismiss()
                        //                    }
                        //                    .foregroundColor(.gray)
                        //                    .padding(.top)
                    }
            .background(.white)
            }
        }
    }
    // Helper function to get subtitle for selected plan
    func getSelectedPlanSubtitle() -> String? {
        switch selectedPlan {
        case "Monthly":
            return "Only $4.99/month, billed monthly, cancel anytime"
        case "Yearly":
            return "Only $1.66/month, billed annually, cancel anytime"
        case "Lifetime":
            return "Pay once, keep forever"
        default:
            return nil
        }
    }
}


//struct Features: Identifiable {
//    let id = UUID()
//    let text: String
//    let icon: String
//     
//    static let all: [Features] = [
//        Features(text: "Unlock 1000s of wisdom on the world's biggest library on success", icon: "books.vertical.fill"),
//        Features(text: "Search through 1000s of quotes, authors and topics from the world's most successful people", icon: "magnifyingglass"),
//        Features(text: "Context - get meaning behind quotes", icon: "lightbulb.max.fill"),
//        Features(text: "Quotes you won't find anywhere else", icon: "star.fill"),
//        Features(text: "No Ads Forever - our commitment to you", icon: "hand.raised.slash.fill"),
//        // Removed the last feature
//    ]
//}

struct FeatureComparison: Identifiable {
    let id = UUID()
    let feature: String
    let basicLimit: String?  // Optional string to show limits like "500 only"
    let isBasicIncluded: Bool
    let isProIncluded: Bool = true  // Pro always includes features
    let icon: String

    static let all: [FeatureComparison] = [
        FeatureComparison(feature: "Access 1000s of wisdom from the world's biggest library on success", basicLimit: "500 only", isBasicIncluded: false, icon: "books.vertical.fill"),
        FeatureComparison(feature: "Search through 1000s of quotes, authors and topics from the world's most successful people", basicLimit: "500 only", isBasicIncluded: false, icon: "magnifyingglass"),
  
//        FeatureComparison(feature: "Save your favourite quotes", basicLimit: nil, isBasicIncluded: true, icon: "heart.fill"),
//        FeatureComparison(feature: "Widgets", basicLimit: nil, isBasicIncluded: true, icon: "apps.iphone"),
//        FeatureComparison(feature: "Get daily notifications", basicLimit: nil, isBasicIncluded: true, icon: "bell.fill"),
//        FeatureComparison(feature: "Author bios", basicLimit: nil, isBasicIncluded: true, icon: "person.fill"),
//        FeatureComparison(feature: "Zero ads, forever", basicLimit: nil, isBasicIncluded: true, icon: "hand.raised.slash.fill"),
        FeatureComparison(feature: "Context - get meaning behind quotes", basicLimit: nil, isBasicIncluded: false, icon: "lightbulb.max.fill"),
        FeatureComparison(feature: "Quotes you won't find anywhere else", basicLimit: nil, isBasicIncluded: false, icon: "star.fill"),
        FeatureComparison(feature: "Categories for every situation", basicLimit: nil, isBasicIncluded: false, icon: "folder.fill"),
//        FeatureComparison(feature: "Share quotes with custom fonts and backgrounds", basicLimit: nil, isBasicIncluded: false, icon: "square.and.arrow.up.fill"),
        FeatureComparison(feature: "Lock screen widgets", basicLimit: nil, isBasicIncluded: false, icon: "lock.square.fill"),
        FeatureComparison(feature: "Add your own quotes - coming soon", basicLimit: nil, isBasicIncluded: false, icon: "plus.square.fill"),
//        FeatureComparison(feature: "Future pro features", basicLimit: nil, isBasicIncluded: false, icon: "sparkles"),
        FeatureComparison(feature: "Remove watermarks", basicLimit: nil, isBasicIncluded: false, icon: "seal.fill")
    ]
}

struct FeatureComparisonView: View {
    var body: some View {
        HStack(spacing: 0) {
            // Feature names column
            VStack(alignment: .leading, spacing: 0) {
                Text("") // Empty header
                    .frame(height: 40)
                ForEach(FeatureComparison.all) { feature in
                    HStack(spacing: 10) {
//                        Image(systemName: feature.icon)
//                            .foregroundColor(.green)
//                            .font(.system(size: 18))
//                            .frame(width: 21) // Fixed
                        Text(feature.feature)
                            .font(.system(size: 14))
                            .multilineTextAlignment(.leading)
                            .frame(height: 55)
                    }
                    
                }
            }
            .frame(maxWidth: .infinity)
//            .padding(.horizontal, 16)
            
            // Free column
            VStack(spacing: 0) {
                Text("Free")
                    .font(.system(size: 16, weight: .medium))
                    .frame(height: 40)
                    .foregroundStyle(.gray)
                ForEach(FeatureComparison.all) { feature in
                    VStack {
                        if let limit = feature.basicLimit {
                            Text(limit)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        } else if feature.isBasicIncluded {
                            Image(systemName: "checkmark")
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(height: 55)
                }
            }
            .frame(width: 50)
            .padding(.vertical)
            
            // Pro column
            VStack(spacing: 0) {
                Text("Pro")
                    .font(.system(size: 16, weight: .medium))
                    .frame(width: 50, height: 40)
                    .background(Color.blue.opacity(0.2))
                ForEach(FeatureComparison.all) { feature in
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                        .frame(height: 55)
                }
            }
            .frame(width: 50)
            .background(Color.blue.opacity(0.2))
            .padding(.vertical)
        }
//        .padding(.horizontal)
    }
}

struct SubPlan: View {
    let title: String
    let price: String
    let period: String
    let features: [String]
    var isFeatured: Bool = false
    var isSelected: Bool = false
    var onSelect: () -> Void = {}
    var subtitle: String? = nil

    var body: some View {
        Button(action: onSelect) {
            if isSelected {
                VStack(alignment: .center, spacing: 16) {

                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text(title)
                            .font(.system(size: 17, weight: .semibold))
                        Spacer()
                        Text(price)
                        //                        .font(.system(size: 36, weight: .bold))
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.black)
                        Circle()
                            .stroke(.black, lineWidth: 2)
                            .frame(width: 24, height: 24)
                            .overlay(
                                Circle()
                                    .fill(.black)
                                    .frame(width: 12, height: 12)
                            )
                    }
                    //
                    //                if isSelected {
                    //                    Text(period)
                    //                        .font(.subheadline)
                    //                        .foregroundColor(.gray)
                    //                }
                    
                        
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(features, id: \.self) { feature in
                            HStack (alignment: .top) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text(feature)
                                    .multilineTextAlignment(.leading)
                                    .font(.system(size: 13))
                                    .fixedSize(horizontal: false, vertical: true)
                                    .lineLimit(nil)
                            }
                        }
                    }
                }
//                    if let subtitle = subtitle {
//                        Text(subtitle)
//                            .font(.system(size: 11))
//                            .foregroundColor(.gray)
//                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundStyle(.black)
                .background(.white)
//                .cornerRadius(16)
//                .padding()
                .cornerRadius(16)
                .shadow(color: isSelected ? .black.opacity(0.1) : .clear, radius: 10)
                
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(title)
                                .font(.system(size: 16/*, weight: isSelected ? .semibold : .regular)*/))
                                .foregroundStyle(.black)
                        }
                        Spacer()
                        Text(price)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.black)
                        Circle()
                            .stroke(isSelected ? Color.white : Color.gray, lineWidth: 2)
                            .frame(width: 24, height: 24)
//                            .overlay(
//                                Circle()
//                                    .fill(isSelected ? Color.white : Color.gray)
//                                    .frame(width: 12, height: 12)
//                            )
                    }

                }
                .padding()
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle()) // This makes the entire area tappable
                .background(isSelected ? Color.white.opacity(0.1) : Color.clear)
                .cornerRadius(12)
    //            .overlay(
    //                RoundedRectangle(cornerRadius: 24)
    //                    .stroke(.gray.opacity(0.3), lineWidth: 2)
    //            )
            }
//            .buttonStyle(PlainButtonStyle())
//            .foregroundStyle(isSelected ? Color.black : Color.white)
//
//            }
        }
    }
}

#Preview {
    PaymentTest()
}
