//
//  SubscriptionManagementView.swift
//  SuccessQuotes
//
//  Created by Barbara on 14/07/2025.
//

import SwiftUI
import StoreKit

struct SubscriptionManagementView: View {
    @StateObject private var storeManager = StoreManager.shared
    @StateObject private var subscriptionManager = SubscriptionManager.shared
    @State private var isPurchasing = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var showFeaturesPopup = false
    @State private var showPlanChangeConfirmation = false
    @State private var selectedProductForChange: Product?
    @State private var selectedPlanId: String?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    
                    // MARK: - Header
                    VStack(spacing: 8) {
                        Text("Manage Your Subscription")
                            .font(.custom("EditorialNew-Ultralight", size: 28))
                            .foregroundColor(.white)
                        
                        Text("You have access to all premium features")
                            .font(.custom("Inter-Regular", size: 14))
                            .foregroundColor(.gray)
                        
                        Divider()
                            .background(.white)
                    }
                    .padding(.top)
                    

                    
                    // MARK: - Current Plan
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
//                            Image(systemName: "crown.fill")
//                                .foregroundColor(.orang)
//                                .font(.title2)
                            Text("Current Plan")
                                .font(.custom("Helvetica Now Display Bold", size: 18))
                                .foregroundColor(.white)
                        }
                        
                        // Show the current plan card
                        if let currentProduct = storeManager.products.filter({ isPremiumAccessProduct($0) }).first(where: { isCurrentPlan($0) }) {
                            SubscriptionPlanCard(
                                product: currentProduct,
                                isCurrentPlan: true,
                                isGreyedOut: false,
                                isPurchasing: isPurchasing,
                                isSelected: false,
                                currentSubscriptionType: subscriptionManager.subscriptionType,
                                onPurchase: {}
                            )
                        }
                        
                        // Show next billing date for subscriptions
                        if let billingDate = getNextBillingDate() {
                            Text("Next billing date on \(billingDate)")
                                .font(.custom("Inter-Regular", size: 13))
                                .foregroundColor(.gray)
                                .padding(.top, 8)
                        }
                    }
                    
                    Divider()
                        .background(.white)
                    
                    // MARK: - Lifetime vs Other Plans
                    if subscriptionManager.subscriptionType == .lifetime {
                        // Simplified view for lifetime users
                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(.green)
                                    .font(.title2)
                                Text("You're all set!")
                                    .font(.custom("Helvetica Now Display Bold", size: 20))
                                    .foregroundColor(.white)
                            }
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Your lifetime membership includes:")
                                    .font(.custom("Inter-Medium", size: 16))
                                    .foregroundColor(.white)
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    LifetimeFeatureRow(icon: "quote.bubble.fill", title: "Unlimited access to all quotes", subtitle: "Browse the world's largest success quote library")
                                    LifetimeFeatureRow(icon: "sparkles", title: "Exclusive premium content", subtitle: "Wisdom you won't find anywhere else")
                                    LifetimeFeatureRow(icon: "bell.fill", title: "Daily notifications", subtitle: "Get inspired every day with personalized quotes")
                                    LifetimeFeatureRow(icon: "textformat", title: "Quote context & insights", subtitle: "Understand the deeper meaning behind each quote")
                                }
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                            
                            HStack {
                                Spacer()
                                Button(action: {
                                    showFeaturesPopup = true
                                }) {
                                    HStack(spacing: 4) {
                                        Text("See all premium features")
                                            .font(.custom("Inter-Regular", size: 14))
                                            .foregroundColor(.white)
                                        Image(systemName: "info.circle")
                                            .foregroundColor(.white)
                                            .font(.caption)
                                    }
                                }
                                Spacer()
                            }
                        }
                    } else {
                        // Regular change plans view for subscription users
                        VStack(alignment: .leading, spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Available Plans")
                                        .font(.custom("Helvetica Now Display Bold", size: 18))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        showFeaturesPopup = true
                                    }) {
                                        HStack(spacing: 4) {
                                            Text("See premium features")
                                                .font(.custom("Inter-Regular", size: 14))
                                                .foregroundColor(.white)
                                            Image(systemName: "info.circle")
                                                .foregroundColor(.white)
                                                .font(.caption)
                                        }
                                    }
                                }
                                
//                                Text("Upgrade, downgrade, or switch your subscription anytime")
//                                    .font(.custom("Inter-Regular", size: 14))
//                                    .foregroundColor(.gray)
                            }
                            
                            VStack(spacing: 12) {
                                // Show subscription products and lifetime purchase (excluding current plan)
                                ForEach(storeManager.products.filter { isPremiumAccessProduct($0) && !isCurrentPlan($0) }, id: \.id) { product in
                                    SubscriptionPlanCard(
                                        product: product,
                                        isCurrentPlan: false,
                                        isGreyedOut: shouldGreyOutPlan(product),
                                        isPurchasing: isPurchasing,
                                        isSelected: selectedPlanId == product.id,
                                        currentSubscriptionType: subscriptionManager.subscriptionType,
                                        onPurchase: {
                                            // No action needed here
                                        }
                                    )
                                    .onTapGesture {
                                        if !shouldGreyOutPlan(product) {
                                            selectedPlanId = product.id
                                        }
                                    }
                                }
                                
                                // Single switch button below all plans
                                if let selectedId = selectedPlanId,
                                   let selectedProduct = storeManager.products.first(where: { $0.id == selectedId }) {
                                    Button(action: {
                                        selectedProductForChange = selectedProduct
                                        showPlanChangeConfirmation = true
                                    }) {
                                        HStack {
                                            if isPurchasing {
                                                ProgressView()
                                                    .scaleEffect(0.8)
                                                    .foregroundColor(.black)
                                            }
                                            Text(getSwitchButtonText(for: selectedProduct))
                                                .font(.custom("Inter-Semibold", size: 16))
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(Color.white)
                                        .foregroundColor(.black)
                                        .cornerRadius(12)
                                    }
                                    .disabled(isPurchasing)
                                    .padding(.top, 12)
                                }
                            }
                        }
                    }
                    
                    // MARK: - Management Actions
                    Divider()
                        .background(.white)
                    
                    VStack(spacing: 16) {
                        // Show different options based on subscription type
                        if subscriptionManager.subscriptionType == .lifetime {
                            // Lifetime users - only show restore and support options
                            Button("Restore Purchases") {
                                Task {
                                    await handleRestorePurchases()
                                }
                            }
                            .font(.custom("Inter-Medium", size: 16))
                            .foregroundColor(.white)
                            .disabled(isPurchasing)
                            
                            Text("Have questions? Contact our support team anytime.")
                                .font(.custom("Inter-Regular", size: 13))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        } else {
                            // Subscription users - show cancel and management options
                            Button("Cancel membership") {
                                openAppStoreSubscriptions()
                            }
                            .font(.custom("Inter-Medium", size: 16))
                            .foregroundColor(.gray)
                            
                            Button("Restore Purchases") {
                                Task {
                                    await handleRestorePurchases()
                                }
                            }
                            .font(.custom("Inter-Medium", size: 16))
                            .foregroundColor(.white)
                            .disabled(isPurchasing)
                            
//                            Text("Cancel or modify your subscription in your Apple ID settings or in the App Store.")
//                                .font(.custom("Inter-Regular", size: 13))
//                                .foregroundColor(.gray)
//                                .multilineTextAlignment(.center)
//                                .padding(.horizontal)
                        }
                    }
                    
                }
                .padding()
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .blur(radius: showFeaturesPopup ? 50 : 0)
            .alert("Subscription Management", isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
            .confirmationDialog(
                "Change Subscription Plan",
                isPresented: $showPlanChangeConfirmation,
                presenting: selectedProductForChange
            ) { product in
                Button("Change to \(getProductTitle(for: product))") {
                    Task {
                        await handlePurchase(product)
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: { product in
                Text(getPlanChangeMessage(for: product))
            }
            .onAppear {
                Task {
                    await storeManager.loadProducts()
                    await subscriptionManager.refreshStatus()
                }
            }
            .overlay(
                // Features Popup Overlay
                Group {
                    if showFeaturesPopup {
                        ZStack {
                            // Semi-transparent overlay
                            Color.black.opacity(0.8)
                                .edgesIgnoringSafeArea(.all)
                                .onTapGesture {
                                    showFeaturesPopup = false
                                }
                            
                            // Popup content
                            FeaturesPopup(onClose: {
                                showFeaturesPopup = false
                            })
                                .cornerRadius(16)
                                .scaleEffect(showFeaturesPopup ? 0.89 : 0.6)
                                .opacity(showFeaturesPopup ? 1.0 : 0.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.8), value: showFeaturesPopup)
                        }
                        .transition(.opacity)
                    }
                }
            )
        }
    }
    
    // MARK: - Helper Methods
    private func isSubscriptionProduct(_ product: Product) -> Bool {
        // Only true auto-renewable subscriptions, not lifetime purchases
        return product.type == .autoRenewable
    }
    
    private func isPremiumAccessProduct(_ product: Product) -> Bool {
        // Include both subscriptions and lifetime purchase (but not AI Context)
        return product.type == .autoRenewable || product.id == ProductIdentifiers.lifetimePremium
    }
    
    private func isCurrentPlan(_ product: Product) -> Bool {
        switch subscriptionManager.subscriptionType {
        case .monthly:
            return product.id == ProductIdentifiers.monthlySubscription
        case .yearly:
            return product.id == ProductIdentifiers.yearlySubscription
        case .lifetime:
            return product.id == ProductIdentifiers.lifetimePremium
        case .none:
            return false
        }
    }
    
    private func shouldGreyOutPlan(_ product: Product) -> Bool {
        // For lifetime users, grey out subscription plans (they can't downgrade)
        if subscriptionManager.subscriptionType == .lifetime {
            return product.type == .autoRenewable
        }
        // For subscription users, don't grey out any plans (allow upgrades/downgrades)
        return false
    }
    
    private func getPlanCaption() -> String {
        switch subscriptionManager.subscriptionType {
        case .monthly:
            return "All premium features in your pocket for a month."
        case .yearly:
            return "All premium features in your pocket for a year."
        case .lifetime:
            return "All premium features in your pocket forever."
        case .none:
            return ""
        }
    }
    
    private func getNextBillingDate() -> String? {
        // This would typically come from the subscription status
        // For now, return a placeholder - in real implementation you'd get this from StoreKit
        switch subscriptionManager.subscriptionType {
        case .monthly:
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date())
        case .yearly:
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date())
        case .lifetime, .none:
            return nil
        }
    }
    
    private func handlePurchase(_ product: Product) async {
        isPurchasing = true
        
        let result = await storeManager.purchase(product)
        
        isPurchasing = false
        
        switch result {
        case .success:
            // Explicitly refresh subscription status to update UI immediately
            await subscriptionManager.refreshStatus()
            showAlert("Success!", "Your subscription has been updated successfully.")
            
        case .cancelled:
            // User cancelled, no need to show alert
            break
            
        case .failed(let error):
            showAlert("Purchase Failed", error.localizedDescription)
            
        case .pending:
            showAlert("Purchase Pending", "Your purchase is pending approval.")
        }
    }
    
    private func handleRestorePurchases() async {
        isPurchasing = true
        
        let success = await storeManager.restorePurchases()
        
        isPurchasing = false
        
        if success {
            // Explicitly refresh subscription status to update UI immediately
            await subscriptionManager.refreshStatus()
            showAlert("Purchases Restored", "Your purchases have been restored successfully.")
        } else {
            showAlert("Restore Failed", "Failed to restore purchases. Please try again.")
        }
    }
    
    private func openAppStoreSubscriptions() {
        if let url = URL(string: "https://apps.apple.com/account/subscriptions") {
            UIApplication.shared.open(url)
        }
    }
    
    private func showAlert(_ title: String, _ message: String) {
        alertMessage = message
        showingAlert = true
    }
    
    private func getProductTitle(for product: Product) -> String {
        switch product.id {
        case ProductIdentifiers.monthlySubscription:
            return "Monthly Premium"
        case ProductIdentifiers.yearlySubscription:
            return "Yearly Premium"
        case ProductIdentifiers.lifetimePremium:
            return "Lifetime Premium"
        default:
            return product.displayName
        }
    }
    
    private func getPlanChangeMessage(for product: Product) -> String {
        let currentPlan = subscriptionManager.subscriptionType
        
        switch product.id {
        case ProductIdentifiers.lifetimePremium:
            return "Upgrade to lifetime access and never pay again. Your current subscription will be cancelled."
        case ProductIdentifiers.yearlySubscription:
            if currentPlan == .monthly {
                return "Upgrade to yearly billing and save money. Your monthly subscription will be replaced."
            } else {
                return "Switch to yearly billing. Your current subscription will be replaced."
            }
        case ProductIdentifiers.monthlySubscription:
            if currentPlan == .yearly {
                return "Switch to monthly billing. Your yearly subscription will be replaced."
            } else {
                return "Switch to monthly billing. Your current subscription will be replaced."
            }
        default:
            return "Your current subscription will be replaced with this plan."
        }
    }
    
    private func getSwitchButtonText(for product: Product) -> String {
        switch product.id {
        case ProductIdentifiers.monthlySubscription:
            return "Switch to Monthly"
        case ProductIdentifiers.yearlySubscription:
            return "Switch to Yearly"
        case ProductIdentifiers.lifetimePremium:
            return "Switch to Lifetime"
        default:
            return "Switch Plan"
        }
    }
}

// MARK: - Status Card
struct StatusCard: View {
    let title: String
    let value: String
    let isPremium: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.custom("Inter-Medium", size: 14))
                    .foregroundColor(.gray)
                
                Text(value)
                    .font(.custom("Inter-Semibold", size: 16))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Image(systemName: isPremium ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(isPremium ? .green : .red)
                .font(.title2)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Subscription Plan Card
struct SubscriptionPlanCard: View {
    let product: Product
    let isCurrentPlan: Bool
    let isGreyedOut: Bool
    let isPurchasing: Bool
    let isSelected: Bool
    let currentSubscriptionType: SubscriptionManager.SubscriptionType
    let onPurchase: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(getProductTitle())
                            .font(.custom("Inter-Bold", size: 16))
                            .foregroundColor(isCurrentPlan ? .orang : (isGreyedOut ? .gray.opacity(0.6) : .white))
                        
                        if isCurrentPlan {
                            Text("ACTIVE")
                                .font(.custom("Inter-Semibold", size: 10))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color.orang)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                    
                    Text(getProductDescription())
                        .font(.custom("Inter-Regular", size: 13))
                        .foregroundColor(isGreyedOut ? .gray.opacity(0.6) : .gray)
                        .lineLimit(nil)
                    
                    Text(getRenewalText())
                        .font(.custom("Inter-Regular", size: 12))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(product.displayPrice)
                        .font(.custom("Inter-Bold", size: 18))
                        .foregroundColor(isCurrentPlan ? .orang : (isGreyedOut ? .gray.opacity(0.6) : .white))
                    
                    if isCurrentPlan {
                        Text("Your Plan")
                            .font(.custom("Inter-Medium", size: 12))
                            .foregroundColor(.orang)
                    }
                }
            }
        }
        .padding()
        .background(Color.black)
        .cornerRadius(12)
        .overlay(
            // Orange border for current plan, white for selected, grey for unselected
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    isCurrentPlan ? Color.orang : (isSelected ? Color.white : Color.gray.opacity(0.3)),
                    lineWidth: 2
                )
        )
    }
    
    private func getProductTitle() -> String {
        switch product.id {
        case ProductIdentifiers.monthlySubscription:
            return "Monthly Premium"
        case ProductIdentifiers.yearlySubscription:
            return "Yearly Premium"
        case ProductIdentifiers.lifetimePremium:
            return "Lifetime Premium Access"
        default:
            return product.displayName
        }
    }
    
    private func getProductDescription() -> String {
        switch product.id {
        case ProductIdentifiers.monthlySubscription:
            return "Monthly access to premium features"
        case ProductIdentifiers.yearlySubscription:
            return "Yearly access to premium features"
        case ProductIdentifiers.lifetimePremium:
            return "Get lifetime access to premium features"
        default:
            return product.description
        }
    }
    
    private func getRenewalText() -> String {
        switch product.id {
        case ProductIdentifiers.monthlySubscription:
            return "Renews monthly"
        case ProductIdentifiers.yearlySubscription:
            return "Renews annually"
        case ProductIdentifiers.lifetimePremium:
            return "One-time purchase"
        default:
            return ""
        }
    }
}


// MARK: - Lifetime Feature Row
struct LifetimeFeatureRow: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.green)
                .font(.title3)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.custom("Inter-Medium", size: 14))
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.custom("Inter-Regular", size: 12))
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            
            Spacer()
        }
    }
}

#Preview {
    SubscriptionManagementView()
}
