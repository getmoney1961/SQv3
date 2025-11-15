//
//  NewShareSheet.swift
//  SuccessQuotes
//
//  Created by Barbara on 26/09/2025.
//

import SwiftUI
import UIKit
import Photos

struct NewShareSheet: View {
    let quote: Quote
    @Environment(\.dismiss) private var dismiss
    @StateObject private var subscriptionManager = SubscriptionManager.shared
    @State private var shareText: String = ""
    @State private var showingSaveAlert = false
    @State private var saveAlertMessage = ""
    @State private var hideWatermark = false
    @State private var showPaymentSheet = false
    
    init(quote: Quote) {
        self.quote = quote
        self._shareText = State(initialValue: "\"\(quote.quote)\" - \(quote.author)")
    }

    var body: some View {
        VStack {
            
//             Close button
            HStack {
                Spacer()
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black.opacity(0.6))
                        .font(.system(size: 16, weight: .medium))
                        .frame(width: 30, height: 30)
                }
            }
            .padding(.horizontal, 1)
            .padding(.top, 16)
//            .hidden()
            
            VStack {
                
                HStack {
                    Text("S")
                        .font(.custom("AppleGaramondLight", size: 36))
                        .foregroundStyle(.red)
                    Spacer()
                }
                Spacer()
                
                VStack (spacing: 16) {
                    Text(quote.quote)
                        .font(.custom("AppleGaramondLight", size: 26))
                        .multilineTextAlignment(.center)
                    Text(" - \(quote.author)")
                        .font(.custom("NewYork-RegularItalic", size: 16))
                        .foregroundStyle(.black.opacity(0.3))
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                // Only show watermark if user is not premium or hasn't enabled hide watermark
                if !subscriptionManager.isPremiumUser || !hideWatermark {
                    HStack {
                        Text("Success Quotes")
                            .font(.custom("NewYork-RegularItalic", size: 12))
//                    Image("logop")
//                        .resizable()
//                        .frame(width: 16, height: 16)
//                    Spacer()
//                    Text("successquotesapp")
//                        .font(.custom("NewYork-RegularItalic", size: 12))
//                        .foregroundStyle(.black.opacity(0.7))
                        Spacer()
                    }
                }
        }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(1))
                    .shadow(color: Color.black.opacity(0.07), radius: 25, x: 0, y: 1)
            )
            
        /*SOCIAL BUTTONS*/
            VStack (spacing: 16) {
//                ScrollView (.horizontal, showsIndicators: false) {
                    HStack {
                        Spacer()
                        ShareButton(imageName: "save2", title: "Save") {
                            saveQuoteAsImage()
                        }
                        Spacer()
//                        ShareButton(imageName: "copy2", title: "Copy") {
//                        }
//                        Spacer()
//                        ShareButton(imageName: "instagram", title: "Stories") {
//                            /*Add insta stories logic*/
//                        }
//                        Spacer()
//                        ShareButton(imageName: "instagram", title: "Post") {
//                            /*Add insta stories logic*/
//                        }
//                        Spacer()
//                        
//                        ShareButton(imageName: "whatsapp", title: "Whatsapp") {
//                            /*Add insta stories logic*/
//                        }
//                        Spacer()
//                        
//                        ShareButton(imageName: "messages", title: "Messages") {
//                            /*Add insta stories logic*/
//                        }
//                        
//                        
//                        ShareButton(imageName: "facebook", title: "Facebook") {
//                            /*Add insta stories logic*/
//                        }
//                        Spacer()
//                        ShareButton(imageName: "twitter", title: "X") {
//                            /*Add insta stories logic*/
//                        }
//                        Spacer()
//                        
//                        ShareButton(imageName: "pinterest", title: "Pinterest") {
//                            /*Add insta stories logic*/
//                        }
//                        Spacer()
//                        
//                        ShareButton(imageName: "more", title: "More") {
//                            /*Add insta stories logic*/
//                        }
//                    }
                }
                
//                HStack {
//                    Spacer()
//                    Button (action: {}) {
//                        VStack {
//                            Image ("save2")
//                                .frame(width: 35, height: 35)
//                                .background(.sharebutton)
//                                .cornerRadius(8)
//                            Text("save")
//                                .font(.custom("Inter", size: 12))
//                        }
//                    }
//                    .buttonStyle(PlainButtonStyle())
//                    
//                    Button(action: {}) {
//                        VStack {
//                            Image ("copy2")
//                                .frame(width: 35, height: 35)
//                                .background(.sharebutton)
//                                .cornerRadius(8)
//                            Text("copy")
//                                .font(.custom("Inter", size: 12))
//                        }
//                    }
//                    .buttonStyle(PlainButtonStyle())
////                    Spacer()
//                }
        }
            .padding(.vertical)
        
        Divider()
        
        HStack {
            HStack {
                Text ("Hide watermark")
                    .foregroundStyle(.black.opacity(0.47))
                Text("Premium")
                    .textCase(.uppercase)
                    .padding(.vertical, 3)
                    .padding(.horizontal, 6)
                    .background(.yellow)
                    .foregroundStyle(.white)
                    .font(.custom("Inter-Medium", size: 8))
                    .cornerRadius(2)
            }
            
            Spacer()
            
            Toggle("", isOn: Binding(
                get: { 
                    // Only return true if user is premium AND has enabled hide watermark
                    subscriptionManager.isPremiumUser && hideWatermark 
                },
                set: { newValue in
                    if subscriptionManager.isPremiumUser {
                        // Premium user can toggle normally
                        hideWatermark = newValue
                    } else {
                        // Non-premium user - show payment sheet
                        showPaymentSheet = true
                    }
                }
            ))
        }
        
        }
        .padding(.horizontal)
        .alert("Saved!", isPresented: $showingSaveAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(saveAlertMessage)
        }
        .sheet(isPresented: $showPaymentSheet) {
            PaymentOnboard(
                onContinue: {
                    showPaymentSheet = false
                    // After successful payment, enable hide watermark
                    if subscriptionManager.isPremiumUser {
                        hideWatermark = true
                    }
                }
                // No onSkip parameter - this removes the skip button
            )
        }
    }
    
    private func saveQuoteAsImage() {
        // Create the same view as displayed but for high-quality export
        let quoteCardView = ZStack {
            Color.clear // Transparent background
            
            VStack {
                HStack {
                    Text("S")
                        .font(.custom("AppleGaramondLight", size: 36))
                        .foregroundStyle(.red)
                    Spacer()
                }
                
                Spacer()
                
                VStack (spacing: 16) {
                    Text(quote.quote)
                        .font(.custom("AppleGaramondLight", size: 26))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                    Text(" - \(quote.author)")
                        .font(.custom("NewYork-RegularItalic", size: 16))
                        .foregroundColor(.black.opacity(0.3))
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                // Only show watermark if user is not premium or hasn't enabled hide watermark
                if !subscriptionManager.isPremiumUser || !hideWatermark {
                    HStack {
                        Text("Success Quotes")
                            .font(.custom("NewYork-RegularItalic", size: 12))
                            .foregroundColor(.black)
                        Spacer()
                    }
                }
            }
            .padding(24)
            .background(.white)
            .cornerRadius(20)
            .frame(width: 400, height: 450)
        }
        .frame(width: 400, height: 450) // Extra space for shadow, previous was 550h
        
        // Use backward-compatible approach for iOS 15+
        if #available(iOS 16.0, *) {
            let renderer = ImageRenderer(content: quoteCardView)
            renderer.scale = 6.0 // High scale for crisp export without affecting layout
            
            if let image = renderer.uiImage {
                savePNGToPhotos(image: image)
            } else {
                saveAlertMessage = "Failed to save quote. Please try again."
                showingSaveAlert = true
            }
        } else {
            // Fallback for iOS 15 and earlier with high-quality rendering
            let hostingController = UIHostingController(rootView: quoteCardView)
            let finalSize = CGSize(width: 500, height: 650)
            
            hostingController.view.frame = CGRect(origin: .zero, size: finalSize)
            hostingController.view.backgroundColor = UIColor.clear
            
            // Add to a temporary window to ensure proper rendering
            let window = UIWindow(frame: CGRect(origin: .zero, size: finalSize))
            window.rootViewController = hostingController
            window.makeKeyAndVisible()
            
            // Force layout to ensure proper rendering
            hostingController.view.setNeedsLayout()
            hostingController.view.layoutIfNeeded()
            
            // Wait a moment for the view to fully render
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                let image = hostingController.view.asImage(scale: 6.0) // High scale for quality
                self.savePNGToPhotos(image: image)
                
                // Clean up
                window.isHidden = true
            }
        }
    }
    
    private func savePNGToPhotos(image: UIImage) {
        // Convert to PNG data to preserve alpha channel
        guard let pngData = image.pngData() else {
            saveAlertMessage = "Failed to convert image to PNG format."
            showingSaveAlert = true
            return
        }
        
        // Request photo library access
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized, .limited:
                    // Save PNG data to photo library
                    PHPhotoLibrary.shared().performChanges({
                        let creationRequest = PHAssetCreationRequest.forAsset()
                        creationRequest.addResource(with: .photo, data: pngData, options: nil)
                    }) { success, error in
                        DispatchQueue.main.async {
                            if success {
                                self.saveAlertMessage = "Ultra high-res quote saved to Photos!"
                            } else {
                                self.saveAlertMessage = "Failed to save quote: \(error?.localizedDescription ?? "Unknown error")"
                            }
                            self.showingSaveAlert = true
                        }
                    }
                case .denied, .restricted:
                    self.saveAlertMessage = "Photo library access denied. Please enable in Settings."
                    self.showingSaveAlert = true
                case .notDetermined:
                    self.saveAlertMessage = "Photo library access not determined."
                    self.showingSaveAlert = true
                @unknown default:
                    self.saveAlertMessage = "Unknown photo library authorization status."
                    self.showingSaveAlert = true
                }
            }
        }
    }
}
    
struct ShareButton: View {
    var imageName: String
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack (spacing: 12) {
                Image (imageName)
                    .frame(width: 70, height: 70)
                    .background(.sharebutton)
                    .cornerRadius(8)
                Text(title)
                    .font(.custom("Inter-Medium", size: 12))
                    .frame(width: 70)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - UIView Extension for iOS 15 compatibility
extension UIView {
    func asImage(scale: CGFloat = UIScreen.main.scale) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        format.opaque = false // Ensure transparency is supported
        format.preferredRange = .extended // Use extended range for better quality
        
        let renderer = UIGraphicsImageRenderer(bounds: bounds, format: format)
        return renderer.image { rendererContext in
            // Clear the background to transparent
            rendererContext.cgContext.clear(bounds)
            
            // Set ultra-high-quality rendering options
            let context = rendererContext.cgContext
            context.interpolationQuality = .high
            context.setShouldAntialias(true)
            context.setAllowsAntialiasing(true)
            context.setShouldSmoothFonts(true)
            context.setAllowsFontSmoothing(true)
            context.setAllowsFontSubpixelPositioning(true)
            context.setAllowsFontSubpixelQuantization(true)
            
            // Render the layer with high quality
            layer.render(in: context)
        }
    }
}

// MARK: - Preview

#Preview {
    NewShareSheet(quote: Quote(
        topic: "Motivation",
        quote: "The only way to do great work is to love what you do.",
        author: "Steve Jobs",
        category: "Business"
    ))
}
