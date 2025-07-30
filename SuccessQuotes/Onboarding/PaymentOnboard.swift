//
//  PaymentOnboard.swift
//  SuccessQuotes
//
//  Created by Barbara on 14/07/2025.
//

import SwiftUI

struct PaymentOnboard: View {
    @State private var selectedPlan: Plan = .year

    enum Plan {
        case month, year, lifetime
    }
    var onContinue: () -> Void
    var body: some View {
        ZStack (alignment: .bottom) {
            ScrollView {
                VStack {
                // Header
                HStack {
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("SQ Premium")
                            .font(.custom("Helvetica Now Display Bold", size: 16))
                            .foregroundColor(.orang)
                        Text("Stick to Limited Plan")
                            .font(.custom("Helvetica Now Display Bold", size: 12))
                            .foregroundColor(.paymentgrey)
                    }
                }
                
                Divider()
                    .background(.white)
                
                // Title
                Text("Invest in your mind - All features for as little as a coffee")
                    .font(.custom("Helvetica Now Display Bold", size: 15))
                    .foregroundColor(.orang)
                    .padding(.bottom, 4)
                
                Divider()
                    .background(.white)
                
                
                // Image
                Image("davinci") // Replace with your asset name
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: 220)
                    .clipped()
                
                Divider()
                    .background(.white)
                
                // What's Included
                HStack {
                    Text("What's Included • See all")
                        .font(.custom("EditorialNew-Ultralight", size: 18)) // Use your serif font
                        .tracking(-0.3) // 1.2 points of letter spacing
                        .padding(.top)
                        .padding(.bottom, 8)
                    Image(systemName: "info.circle")
                        .foregroundColor(.orang)
                }
                .padding(.bottom, 4)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        Image("checkcircle")
                            .resizable()
                            .frame(width: 24, height: 24)
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Context")
                                .font(.custom("Inter-Regular", size: 19))
                            Text("Explore deeper meaning behind quotes, add depth instead of just flashy words")
                                .font(.custom("Inter-Regular", size: 15))
                                .foregroundColor(.paymentgrey)
                        }
                    }
                    
                    HStack {
                        Image("checkcircle")
                            .resizable()
                            .frame(width: 24, height: 24)
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Full access to the world’s biggest library on success")
                                .font(.custom("Inter-Regular", size: 19))
                            Text("Over 1000+ wisdom from the worlds most successful people")
                                .font(.custom("Inter-Regular", size: 15))
                                .foregroundColor(.paymentgrey)
                        }
                    }
                    
                    HStack {
                        Image("checkcircle")
                            .resizable()
                            .frame(width: 24, height: 24)
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Exclusive quotes")
                                .font(.custom("Inter-Regular", size: 19))
                            Text("Wisdom you won’t find anywhere else")
                                .font(.custom("Inter-Regular", size: 15))
                                .foregroundColor(.paymentgrey)
                        }
                    }
                    
                    HStack {
                        Image("checkcircle")
                            .resizable()
                            .frame(width: 24, height: 24)
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Set notifications for daily motivation")
                                .font(.custom("Inter-Regular", size: 19))
                            Text("Inspiration at your fingertips")
                                .font(.custom("Inter-Regular", size: 15))
                                .foregroundColor(.paymentgrey)
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 400) // Add enough bottom padding so last content isn't hidden behind the plan section
            }
            
            VStack (alignment: .leading) {
                        // Plan Selection
                        Text("Choose a plan that works for you")
                            .font(.custom("EditorialNew-Ultralight", size: 20)) // Use your serif font
                        
                        Divider()
                            .background(.white)
                        
                        VStack(spacing: 16) {
                            PlanRow(title: "1 Month Access", subtitle: "Billed monthly", price: "$4.99", detail: "$59.88/year", isSelected: selectedPlan == .month) {
                                selectedPlan = .month
                            }
                            PlanRow(title: "1 Year Access", subtitle: "Billed annually", price: "$24.99", detail: "$2.08/month", isSelected: selectedPlan == .year, highlight: true) {
                                selectedPlan = .year
                            }
                            PlanRow(title: "Lifetime Access", subtitle: "Pay once, never pay again", price: "$79.99", detail: nil, isSelected: selectedPlan == .lifetime) {
                                selectedPlan = .lifetime
                            }
                        }
                        
                        // CTA Button
                        Button(action: {
                            onContinue()
                        }) {
                            Text("Invest in your mind - \(selectedPlan == .month ? "$4.99" : selectedPlan == .year ? "$24.99" : "$79.99")")
                                .font(.custom("Inter-Regular", size: 17))
                                .frame(maxWidth: .infinity)
                                .padding(22)
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(32)
                        }
                        .padding(.top, 24)
                    }
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: Color.black.opacity(0), location: 1),   // Transparent black at the top
                                .init(color: Color.black, location: 0.93)               // Solid black at the bottom
                            ]),
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
            .foregroundColor(.white)
        }
    }
    

// Helper for plan rows
struct PlanRow: View {
    let title: String
    let subtitle: String
    let price: String
    let detail: String?
    let isSelected: Bool
    var highlight: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack (spacing: 10) {
                HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(title)
                            .font(.custom("Inter-Medium", size: 14))
                            .foregroundColor(isSelected ? .black : .white) // <-- changed
                        if highlight {
                            Text("Most Popular")
                                .font(.custom("Inter-Semibold", size: 11))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color.orang)
                                .foregroundColor(.black)
                                .cornerRadius(6)
                                .padding(.vertical, -4)
                        }
                    }
                    VStack (alignment: .leading, spacing: 2) {
                        Text(subtitle)
                            .font(.custom("Inter-Light", size: 12))
                            .foregroundColor(isSelected ? .black : .white) // <-- changed
                    }
                }
                Spacer()
                VStack (alignment: .trailing, spacing: 3) {
                    Text(price)
                        .font(.custom("Inter-Medium", size: 14))
                        .foregroundColor(isSelected ? .black : .white) // <-- changed
                    if let detail = detail {
                        Text(detail)
                            .font(.custom("Inter-Light", size: 13))
                            .foregroundColor(isSelected ? .black : .white) // <-- changed
                    }
                }
            }

                // Radio Button
                ZStack {
                    if isSelected {
                        Image("blackcheck")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .foregroundColor(.white)
                    } else {
                        Circle()
                            .stroke(Color.gray, lineWidth: 2)
                            .frame(width: 28, height: 28)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical)
            .background(isSelected ? Color.white : Color.clear)
            .cornerRadius(32)
        }
        .foregroundColor(.white)
    }
}

#Preview {
    PaymentOnboard(onContinue: {})
}
