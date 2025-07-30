//
//  Highend.swift
//  SuccessQuotes
//
//  Created by Barbara on 31/01/2025.
//

import SwiftUI

struct Highend: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedPlan: PlanType = .yearly
    @State private var isPulsating = false
    @State private var limitedPlanOpacity = 0.0
    
    enum PlanType: String {
        case monthly = "Monthly Access"
        case yearly = "Annual Access"
        case lifetime = "Lifetime Access"
        
        var price: Decimal {
            switch self {
            case .monthly: return 4.99
            case .yearly: return 19.99
            case .lifetime: return 75.99
            }
        }
        
        var subtitle: String {
            switch self {
            case .monthly: return "Full access, billed monthly"
            case .yearly: return "Save 67% annually"
            case .lifetime: return "One-time payment, forever access"
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 32) {
                // Header
                VStack(spacing: 16) {
                    Text("Think Different")
                        .font(.custom("EditorialNew-Regular", size: 40))
                        .foregroundColor(.white)
                    
                    Text("Join the world's most successful people\nin their journey to excellence")
                        .font(.system(size: 16))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                }
                .padding(.top, 48)
                
                // Key Features
                VStack(spacing: 24) {
                    FeatureRow(icon: "sparkles", text: "1000+ exclusive success wisdom")
                    FeatureRow(icon: "brain.head.profile", text: "Deep context behind every quote")
                    FeatureRow(icon: "lock.shield", text: "Premium features & future updates")
                }
                .padding(.horizontal, 24)
                
                // Subscription Plans
                VStack(spacing: 16) {
                    ForEach([PlanType.monthly, .yearly, .lifetime], id: \.self) { plan in
                        PlanButton2(
                            plan: plan,
                            isSelected: selectedPlan == plan,
                            action: { selectedPlan = plan }
                        )
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 16) {
                    Button(action: {
                        // Handle purchase
                    }) {
                        Text("Unlock Your Potential")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 24)
                    
                    Button("Restore Purchase") {
                        // Handle restore
                    }
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                }
                .padding(.bottom, 32)
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.white)
            Text(text)
                .font(.system(size: 16))
                .foregroundColor(.white)
            Spacer()
        }
    }
}

struct PlanButton2: View {
    let plan: Highend.PlanType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(plan.rawValue)
                        .font(.system(size: 16, weight: .medium))
                    Text(plan.subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                Spacer()
                Text("$\(String(format: "%.2f", plan.price as NSDecimalNumber))")
                    .font(.system(size: 16, weight: .semibold))
            }
            .padding(16)
            .background(isSelected ? Color.white.opacity(0.1) : Color.clear)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.white : Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
        .foregroundColor(.white)
    }
}

#Preview {
    Highend()
}
