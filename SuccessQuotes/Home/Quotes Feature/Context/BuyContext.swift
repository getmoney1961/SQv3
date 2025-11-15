//
//  BuyContext.swift
//  SuccessQuotes
//
//  Created by Barbara on 03/10/2025.
//

import SwiftUI
import VisualEffectView

struct BuyContext: View {
    var onDismiss: () -> Void
    
    @StateObject private var storeManager = StoreManager.shared
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var isPurchasing = false
    @State private var showPaymentPage = false
    
    var body: some View {
        ZStack {

            VisualEffect(colorTint: .black, colorTintAlpha: 0.25, blurRadius: 1, scale: 1)
                .ignoresSafeArea()

        VStack {
            //Title
            HStack {
                Spacer()
                Text("Unlock Context")
                Image(systemName: "lock.fill")
                Spacer()
                // Dismiss button
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white)
                        .padding(8)
                        .background(Circle().fill(Color.white.opacity(0.2)))
                }
            }
            .foregroundStyle(.buycontexttitle)
            .font(.custom("Inter Regular", size: 16))
            
            // Line
            Divider()
                .background(.buycontextline)
            
            // Features
            HStack {
                VStack (alignment: .leading, spacing: 0) {
                    
                    // Feature slugline
                    Text("Learn quote history")
                        .font(.custom("Inter Light", size: 16))
                        .padding(.top)
                        .foregroundStyle(.white)
                    // Feature List
                    ContextFeatureList()
                }
                Spacer()
            }
            // Buttons
            VStack (spacing: 8) {
                Button(action:{
                    Task {
                        await purchaseContextFeature()
                    }
                }) {
                    HStack {
                        Spacer()
                        if isPurchasing {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        } else {
                            VStack (spacing: 2) {
                                HStack {
                                    Text("Try Context")
                                    if let product = storeManager.getProduct(for: ProductIdentifiers.aiContextFeature) {
                                        Text(product.displayPrice)
                                    } else {
                                        Text("$1.99")
                                    }
                                }
                                .font(.custom("Adobe Caslon Pro Semibold", size: 16))
                                .foregroundStyle(.black)
                                Text("Hassle-free one time use")
                                    .font(.custom("Inter Medium", size: 11))
                                    .foregroundStyle(.buycontextcaption)
                            }
                        }
                        Spacer()
                    }
                    .padding()
                    .background(.white)
                    .cornerRadius(32)
                }
                .disabled(isPurchasing || storeManager.hasAIContextFeature())
                
                Button(action:{
                    showPaymentPage = true
                }) {
                    HStack {
                        Spacer()
                        VStack (spacing: 2) {
                            Text("Subscribe to Premium")
                                .font(.custom("Adobe Caslon Pro Semibold", size: 16))
                                .foregroundStyle(.white)
                            Text("All pro features + context")
                                .font(.custom("Inter Medium", size: 11))
                                .foregroundStyle(.buycontextcaption)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 35)
                            .fill(.buycontextbg)
                            .overlay(
                                RoundedRectangle(cornerRadius: 35)
                                    .stroke(Color.white, lineWidth: 1)
                            )
                    )
                    .cornerRadius(32)
                }
                .disabled(storeManager.isPremiumUser())
            }
        }
        .padding(.horizontal)
        .padding(.top, 32)
        .padding(.bottom, 48)
        .background(.buycontextbg)
        .cornerRadius(24)
        .padding()
        .alert("Error", isPresented: $showingError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .sheet(isPresented: $showPaymentPage) {
            PaymentOnboard(
                onContinue: {
                    showPaymentPage = false
                    onDismiss()
                }
            )
        }
    }
    }
    
    // MARK: - Purchase Functions
    private func purchaseContextFeature() async {
        guard let product = storeManager.getProduct(for: ProductIdentifiers.aiContextFeature) else {
            errorMessage = "Product not available. Please try again later."
            showingError = true
            return
        }
        
        isPurchasing = true
        let result = await storeManager.purchase(product)
        isPurchasing = false
        
        switch result {
        case .success:
            // Dismiss the view on successful purchase
            onDismiss()
        case .cancelled:
            // User cancelled, do nothing
            break
        case .pending:
            errorMessage = "Purchase is pending approval."
            showingError = true
        case .failed(let error):
            errorMessage = error.localizedDescription
            showingError = true
        }
    }
}

struct ContextFeatureList: View {
    var body: some View {
        VStack (alignment: .leading) {
            ContextFeature(featureName: "Historical context")
            ContextFeature(featureName: "Background")
            ContextFeature(featureName: "Quote Breakdown & meaning")
            ContextFeature(featureName: "Key Works")
        }
        .padding(.vertical, 24)
    }
}

struct ContextFeature: View {
    var featureName: String
    
    var body: some View {
        HStack {
            Image("check.circle")
            Text(featureName)
                .foregroundStyle(.white)
                .font(.custom("Inter Light", size: 16))
        }
    }
}
#Preview {
    BuyContext(onDismiss: {})
}
