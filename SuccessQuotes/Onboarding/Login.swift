//
//  Login.swift
//  SuccessQuotes
//
//  Created by Barbara on 05/01/2025.
//

import SwiftUI

struct Login: View {
    @State private var currentPage = 0
    @State private var showSubscription = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                TabView(selection: $currentPage) {
                    // First Page
                    OnboardingPage(
                        image: "lightbulb.fill",
                        title: "Welcome to Success Quotes",
                        description: "Your journey to a successful life begins here",
                        currentPage: currentPage,
                        totalPages: 3
                    )
                    .tag(0)
                    
                    // Second Page
                    OnboardingPage(
                        image: "book.fill",
                        title: "Daily Inspiration",
                        description: "Get daily quotes from successful people around the world",
                        currentPage: currentPage,
                        totalPages: 3
                    )
                    .tag(1)
                    
                    // Third Page
                    OnboardingPage(
                        image: "star.fill",
                        title: "Premium Features",
                        description: "Access exclusive content and features with our premium subscription",
                        currentPage: currentPage,
                        totalPages: 3
                    )
                    .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                VStack {
                    Spacer()
                    Button(action: {
                        if currentPage < 2 {
                            withAnimation {
                                currentPage += 1
                            }
                        } else {
                            showSubscription = true
                        }
                    }) {
                        Text(currentPage == 2 ? "Get Started" : "Next")
                            .fontWeight(.bold)
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity, maxHeight: 48)
                            .background(.white)
                            .cornerRadius(16)
                            .padding(.horizontal, 48)
                    }
                    .padding(.bottom, 32)
                    
                    Text("Already a member?  Sign in")
                        .foregroundStyle(.gray)
                }
            }
            .sheet(isPresented: $showSubscription) {
                SubscriptionView()
            }
        }
    }
}

struct OnboardingPage: View {
    let image: String
    let title: String
    let description: String
    let currentPage: Int
    let totalPages: Int
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: image)
                .font(.system(size: 80))
                .foregroundColor(.white)
                .padding(.bottom, 32)
            
            Text(title)
                .font(.custom("EditorialNew-Regular", size: 32))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text(description)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            // Page indicators
            HStack(spacing: 8) {
                ForEach(0..<totalPages, id: \.self) { page in
                    Circle()
                        .fill(page == currentPage ? Color.white : Color.gray)
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.top, 48)
        }
        .padding()
    }
}


struct SubscriptionView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedPlan: String = ""  // Add selected plan state
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Header
                    Text("Choose Your Plan")
                        .font(.custom("EditorialNew-Regular", size: 32))
                        .padding(.top, 32)
                    
                    // Subscription Plans
                    VStack(spacing: 16) {
                        SubscriptionPlanCard(
                            title: "Monthly",
                            price: "$4.99",
                            period: "per month",
                            features: ["Daily Quotes", "Save Favorites", "Share Quotes"],
                            isSelected: selectedPlan == "Monthly",
                            onSelect: { selectedPlan = "Monthly" }
                        )
                        
                        SubscriptionPlanCard(
                            title: "Yearly",
                            price: "$39.99",
                            period: "per year",
                            features: ["All Monthly Features", "Premium Content", "No Ads"],
                            isFeatured: true,
                            isSelected: selectedPlan == "Yearly",
                            onSelect: { selectedPlan = "Yearly" }
                        )
                    }
                    .padding(.horizontal)
                    
                    // Continue with free version button
                    Button("Continue with Free Version") {
                        dismiss()
                    }
                    .foregroundColor(.gray)
                    .padding(.top)
                }
            }
            .navigationBarItems(trailing: Button("Skip") {
                dismiss()
            })
        }
    }
}

struct SubscriptionPlanCard: View {
    let title: String
    let price: String
    let period: String
    let features: [String]
    var isFeatured: Bool = false
    var isSelected: Bool = false
    var onSelect: () -> Void = {}
    
    var body: some View {
        VStack(spacing: 16) {
            Text(title)
                .font(.headline)
            
            Text(price)
                .font(.system(size: 36, weight: .bold))
            
            if isSelected {
                Text(period)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(features, id: \.self) { feature in
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text(feature)
                    }
                }
            }
            
            Button("Subscribe") {
                onSelect()
            }
            .foregroundStyle(isFeatured ? .white : .black)
            .frame(maxWidth: .infinity, maxHeight: 48)
            .background(isFeatured ? .black : .gray.opacity(0.1))
            .cornerRadius(16)
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: isFeatured ? .black.opacity(0.1) : .clear, radius: 10)
    }
}

#Preview {
    Login()
}
