//
//  CustomShareSheet.swift
//  SuccessQuotes
//
//  Created by Barbara on 09/11/2024.
//

import SwiftUI
import UIKit

struct CustomShareSheet: View {
    let quote: Quote
    @State private var viewController: UIViewController?
    @Environment(\.presentationMode) var presentationMode
    @State private var currentIndex: Int = 0  // Add this state variable


    
     var body: some View {
         ZStack {
//             Color(red: 0.981, green: 0.976, blue: 0.976).ignoresSafeArea(.all)
//             Color.green.ignoresSafeArea(.all)

                 VStack {

                     CustomTest(quote: quote, currentIndex: $currentIndex)  // Pass the binding
//                         .frame(maxWidth: .infinity, maxHeight: 360)
                         .padding()
                     //                 VStack (alignment: .center) {
                     //                     Spacer()
                     //                     QuoteSharedSheet(quote: quote)
                     //
                     //                     Watermark()
                     //
                     //                     Spacer()
                     //                 }
                     //                 .padding()
//                                      .frame(width: 300, height: 450)
                     //                 .background(.black.opacity(0.9))
                     //                 .cornerRadius(16)
//                         .frame(height: 450)
//                         .background(.yellow)
                     VStack {
                         ScrollView (.horizontal, showsIndicators: false) {
                             HStack {
                                 CustomActionButton(iconName: "square.and.arrow.down", label: "Save Image") {
                                     
                                 }
                                 
                                 CustomActionButton(iconName: "doc.on.doc", label: "Copy Text") {
                                     
                                 }
                                 
                                 CustomActionButton(iconName: "eye.slash", label: "Hide Watermark") {
                                     
                                 }
                             }
                         }
                         .padding(.horizontal)


                         
                         VStack {
                             HStack {
                                 CustomSocialsButton(image: "instagram", label: "Stories") {
                                     DispatchQueue.main.async {
                                         shareToInstagramStories(quote: quote, from: viewController)
                                     }
                                 }
                                 
                                 Spacer()
                                 
                                 CustomSocialsButton(image: "instagram", label: "Post") {
                                     DispatchQueue.main.async {
                                         shareToInstagramPost(quote: quote, from: viewController)
                                     }
                                 }
                                 Spacer()
                                 
                                 CustomSocialsButton(image: "whatsapp", label: "WhatsApp") {
                                     shareToWhatsApp(quote: quote)
                                 }
                                 Spacer()
                                 
                                 CustomSocialsButton(image: "messages", label: "Messages") {
                                     shareToMessages(quote: quote)
                                 }
                                 Spacer()
                                 
                                 CustomSocialsButton(image: "twitter", label: "X") {
                                     shareToTwitter(quote: quote)
                                 }
                                 
                                 
                             }
                             HStack {
                                 CustomSocialsButton(image: "facebook", label: "Feed") {
                                     shareToFacebookFeed(quote: quote)
                                 }
                                 Spacer()
                                 
                                 CustomSocialsButton(image: "facebook", label: "Stories") {
                                     shareToFacebookStories(quote: quote)
                                 }
                                 Spacer()
                                 
                                 CustomSocialsButton(image: "messenger", label: "Messenger") {
                                     shareToMessenger(quote: quote)
                                 }
                                 Spacer()
                                 
                                 CustomSocialsButton(image: "link", label: "Copy Link") {
                                     copyLink(quote: quote)
                                 }
                                 Spacer()
                                 
                                 ShareButton(quote: quote)
                                 
                             }
                         }
                                          .padding(.horizontal)

                         
                         ViewControllerHolder { vc in
                             viewController = vc
                         }
                         .frame(width: 0, height: 0)
                     }
//                     .frame(height: .infinity, alignment: .bottom)
//                     .background(.blue)
                 }

                 //             .background(Color.white)
                 //             .cornerRadius(20)
                 //             .shadow(radius: 10)
                 //             .padding()
             //         .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all))
         }
    }
    
    // Add this new function
    func generateQuoteImage(quote: Quote) -> UIImage? {
        // Use the device's screen scale (typically 2x or 3x)
        let scale = UIScreen.main.scale
        let baseSize = CGSize(width: 360, height: 360) // Base size for the quote view
        let storiesSize = CGSize(width: 1080, height: 1920) // Instagram Stories size

        // Determine background color based on currentIndex
        let backgroundColor: Color = {
            switch currentIndex {
            case 0: // Default
                return .white
            case 1: // Mono
                return Color(red: 255/255, green: 250/255, blue: 229/255) // Light yellow
            case 2: // Bold
                return Color(red: 225/255, green: 59/255, blue: 48/255) // Red
            case 3: // Groovy
                return Color(red: 25/255, green: 25/255, blue: 25/255) // Dark gray
            case 4: // Corp
                return Color(red: 229/255, green: 241/255, blue: 255/255) // Light blue
            case 5: // Regular
                return .black
            default:
                return .white
            }
        }()
        
        // Create the quote view
        let quoteView = CustomTest(quote: quote, currentIndex: .constant(currentIndex))
            .frame(width: baseSize.width, height: baseSize.height)
            .background(backgroundColor)

        // Create a container view that centers the quote view vertically
        let containerView = ZStack {
            backgroundColor.ignoresSafeArea()
            VStack {
//                Spacer()
                quoteView
                    .padding(.bottom, 50) // Adjust this value to move the image up
//                Spacer()
            }
        }
        .frame(width: storiesSize.width / scale, height: storiesSize.height / scale)

        let controller = UIHostingController(rootView: containerView)
        controller.view.frame = CGRect(origin: .zero, size: CGSize(width: storiesSize.width / scale, height: storiesSize.height / scale))
        controller.view.backgroundColor = .clear

        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        let renderer = UIGraphicsImageRenderer(size: controller.view.bounds.size, format: format)

        let image = renderer.image { context in
            controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }

        return image
    }
    
    func shareToInstagramPost(quote: Quote, from viewController: UIViewController?) {
        guard let viewController = viewController,
              let quoteImage = generateQuoteImage(quote: quote) else {
            print("Failed to generate image")
            return
        }
        
        guard let imageData = quoteImage.pngData() else {
            print("Failed to create image data")
            return
        }
        
        // Save the image to the photo library
        UIImageWriteToSavedPhotosAlbum(quoteImage, nil, nil, nil)

        // Use the Instagram URL scheme to share the image
        let items: [String: Any] = [
            "com.instagram.sharedSticker.stickerImage": imageData
        ]
        
        UIPasteboard.general.setItems([items], options: [.expirationDate: Date().addingTimeInterval(300)])
        
        guard let instagramURL = URL(string: "instagram://library?AssetPath=\(imageData)") else {
            print("Could not create Instagram URL")
            return
        }
        
        if let windowScene = viewController.view.window?.windowScene {
            windowScene.open(instagramURL, options: nil) { success in
                if !success {
                    print("Failed to open Instagram")
                }
            }
        } else {
            print("No active window scene found")
        }
    }
    
    
    // Update the sharing function to be more robust
    func shareToInstagramStories(quote: Quote, from viewController: UIViewController?) {
        guard let viewController = viewController,
              let quoteImage = generateQuoteImage(quote: quote) else {
            print("Failed to generate image")
            return
        }
        
        guard let imageData = quoteImage.pngData() else {
            print("Failed to create image data")
            return
        }

        let items: [String: Any] = [
            "com.instagram.sharedSticker.backgroundImage": imageData, // Changed to backgroundImage
            "source_application": "114605711897349"
        ]
        
        UIPasteboard.general.setItems([items], options: [.expirationDate: Date().addingTimeInterval(300)])
        
        guard let instagramURL = URL(string: "instagram-stories://share?source_application=114605711897349") else {
            print("Could not create Instagram Stories URL")
            return
        }
        
        if let windowScene = viewController.view.window?.windowScene {
            windowScene.open(instagramURL, options: nil) { success in
                if !success {
                    print("Failed to open Instagram Stories")
                }
            }
        }
    }

    func shareToWhatsApp(quote: Quote) {
        let text = "\(quote.quote) - \(quote.author)"
        let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let whatsappURL = URL(string: "whatsapp://send?text=\(encodedText)")
        
        if let windowScene = viewController?.view.window?.windowScene {
            if let url = whatsappURL {
                windowScene.open(url, options: nil) { success in
                    if !success {
                        // Fallback to web WhatsApp
                        if let webURL = URL(string: "https://web.whatsapp.com") {
                            windowScene.open(webURL, options: nil)
                        }
                    }
                }
            }
        }
    }
    
    func shareToMessages(quote: Quote) {
        let text = "\(quote.quote) - \(quote.author)"
        if let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: "sms:&body=\(encodedText)") {
            if let windowScene = viewController?.view.window?.windowScene {
                windowScene.open(url, options: nil)
            }
        }
    }
    
    func shareToTwitter(quote: Quote) {
        let text = "\(quote.quote) - \(quote.author)"
        let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let twitterURL = URL(string: "twitter://post?message=\(encodedText)")
        
        if let windowScene = viewController?.view.window?.windowScene {
            if let url = twitterURL {
                windowScene.open(url, options: nil) { success in
                    if !success {
                        // Fallback to web Twitter
                        if let webURL = URL(string: "https://twitter.com/intent/tweet?text=\(encodedText)") {
                            windowScene.open(webURL, options: nil)
                        }
                    }
                }
            }
        }
    }
    
    func shareToFacebookFeed(quote: Quote) {
        let text = "\(quote.quote) - \(quote.author)"
        let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: "fb://post?message=\(encodedText)") {
            if let windowScene = viewController?.view.window?.windowScene {
                windowScene.open(url, options: nil) { success in
                    if !success {
                        // Fallback to web Facebook
                        if let webURL = URL(string: "https://www.facebook.com/sharer/sharer.php?u=\(encodedText)") {
                            windowScene.open(webURL, options: nil)
                        }
                    }
                }
            }
        }
    }
    
    func shareToFacebookStories(quote: Quote) {
        // Similar to Instagram Stories implementation but with Facebook's URL scheme
        guard let viewController = viewController else { return }
        
        // Create and prepare image similar to Instagram Stories
        // ... (use the same image creation code as Instagram Stories)
        
        let backgroundTopColor = "#000000"
        let backgroundBottomColor = "#000000"
        
        guard let url = URL(string: "facebook-stories://share") else { return }
        
        if let windowScene = viewController.view.window?.windowScene {
            windowScene.open(url, options: nil)
        }
    }
    
    func shareToMessenger(quote: Quote) {
        let text = "\(quote.quote) - \(quote.author)"
        let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: "fb-messenger://share/?link=\(encodedText)") {
            if let windowScene = viewController?.view.window?.windowScene {
                windowScene.open(url, options: nil) { success in
                    if !success {
                        // Fallback to web Messenger
                        if let webURL = URL(string: "https://www.messenger.com") {
                            windowScene.open(webURL, options: nil)
                        }
                    }
                }
            }
        }
    }

    func copyLink(quote: Quote) {
        let text = "\(quote.quote) - \(quote.author)"
        UIPasteboard.general.string = text
    }
    
}

extension String {
    func replacingStraightQuotes() -> String {
        var result = self
        if let firstIndex = result.firstIndex(of: "\"") {
            result.replaceSubrange(firstIndex...firstIndex, with: "“")
        }
        if let lastIndex = result.lastIndex(of: "\"") {
            result.replaceSubrange(lastIndex...lastIndex, with: "”")
        }
        return result
    }
}



// Add this representable to get the view controller
struct ViewControllerHolder: UIViewControllerRepresentable {
    let onReady: (UIViewController) -> Void

    func makeUIViewController(context: Context) -> UIViewController {
        let vc = UIViewController()
        DispatchQueue.main.async {
            onReady(vc)
        }
        return vc
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}


struct CustomActionButton: View {
    let iconName: String
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: iconName)
                    .font(.system(size: 14))
                Text(label)
                    .font(.system(size: 12))
            }
            .foregroundStyle(.black)
            .padding(EdgeInsets(top: 13, leading: 20, bottom: 13, trailing: 20))
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.gray.opacity(0.5), lineWidth: 1)
            )
        }
    }
}

struct CustomSocialsButton: View {
    let image: String
    let label: String
    let action: () -> Void
    let viewController: UIViewController?
    
    // Add an initializer to make the viewController parameter optional
    init(image: String, label: String, action: @escaping () -> Void, viewController: UIViewController? = nil) {
        self.image = image
        self.label = label
        self.action = action
        self.viewController = viewController
    }
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(image)
                    .resizable()
                    .frame(width: 32, height: 32)
                    .padding(4)
                    .background(Color.white)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 16)
//                            .stroke(.gray.opacity(0.9), lineWidth: 1)
//                    )
                
                Text(label)
                    .font(.system(size: 12))
            }
            .padding(4)
            .foregroundStyle(.black)
        }
    }
}


struct QuoteSharedSheet: View {
    let quote: Quote
    
    var body: some View {
        Text(quote.quote)
                .font(.system(size: 20))
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .padding()
    }
}

struct Watermark: View {
    var body: some View {
        HStack {
            Image("successquotes.logo")
                .resizable()
                .frame(width: 24, height: 24)
            Text("successquotes.app")
                .font(.system(size: 12))

        }
        .padding(4)
        .background(.yellow)
        .cornerRadius(8)
    }
}

struct ShareButton: View {
    @State private var isShareSheetPresented = false
    let quote: Quote  // Pass the quote object to the view

    var body: some View {
        Button(action: {
            isShareSheetPresented = true
        }) {
            VStack {
                Image("menu")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .padding(4)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 32)
                            .stroke(.gray.opacity(0.9), lineWidth: 1)
                    )
                Text("more")
                    .foregroundStyle(.black)
                    .font(.system(size: 12))
            }
        }
        .sheet(isPresented: $isShareSheetPresented) {
            ActivityView(activityItems: ["\(quote.quote) - \(quote.author)"])
        }
    }
    
    // Helper UIViewControllerRepresentable for UIActivityViewController
    struct ActivityView: UIViewControllerRepresentable {
        var activityItems: [Any]
        var applicationActivities: [UIActivity]? = nil

        func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
            return UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        }

        func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityView>) {}
    }
}



#Preview {
    CustomShareSheet(quote: Quote(topic: "Inspiration", quote: "The only way to do great work is to love what you do.", author: "Steve Jobs"))
        .environmentObject(QuoteManager())

}
