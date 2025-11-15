//
//  ContextView.swift
//  SuccessQuotes
//
//  Created by Barbara on 28/11/2024.
//

import SwiftUI

struct ContextView: View {
    let context: QuoteContext?
    let isLoading: Bool
    var onDismiss: () -> Void
    @State private var isShareSheetPresented = false
    @StateObject private var subscriptionManager = SubscriptionManager.shared
    
    var body: some View {
        ZStack {
        VStack {
            VStack(spacing: 0) {
                if isLoading {
                    VStack {
                        Spacer()
                        ProgressView("Loading context...")
                            .font(.system(size: 16, weight: .medium))
                        Spacer()
                    }
                    
                } else if let context = context {
                    VStack(spacing: 0) {
                        
                        // Title
                        HStack (alignment: .lastTextBaseline) {
                            Image(systemName: "lightbulb.max.fill")
                            Text("Context -")
                                .font(.custom("Adobe Caslon Pro", size: 16))
                            
                            // Author Name & Lifespan
                            HStack (alignment: .center, spacing: 4) {
                                Text(context.authorName)
                                    .font(.custom("Helvetica Now Display XBold", size: 18))
                                
                                // Format: (b. 1918-1998) or (b. 1918-) if death year unknown
                                if let birthYear = context.birthYear {
                                    if let deathYear = context.deathYear {
                                        Text("(b. \(birthYear)-\(deathYear))")
                                            .font(.custom("Helvetica Now Display Light", size: 18))
                                    } else {
                                        Text("(b. \(birthYear)-)")
                                            .font(.custom("Helvetica Now Display Light", size: 18))
                                    }
                                }
                                Spacer()
                            }
                            .foregroundStyle(.contextauthor)
                            Spacer()
                        }
                        .padding(.top, 8)
                        .padding(.bottom)
                        
                        
                        // Scrollable content area
                        ScrollView(showsIndicators: false) {
                            
                            //         Author & lifespan
                            //            HStack (alignment: .center, spacing: 2) {
                            //                Text("Nelson Mandela")
                            //                    .font(.custom("Helvetica Now Display XBold", size: 18))
                            //                Text("(1918-2013)")
                            //                    .font(.custom("Helvetica Now Display Light", size: 18))
                            //                Spacer()
                            //            }
                            //            .foregroundStyle(.contextauthor)
                            
                            //QUOTE
                            VStack {
                                HStack {
                                    Image ("contextmarkleft")
                                    Spacer()
                                }
                                .padding(4)
                                Text(context.quote)
                                    .font(.custom("Adobe Caslon Pro", size: 16))
                                    .foregroundStyle(.black)
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(6)
                                    .padding(.horizontal)
                                HStack {
                                    Spacer()
                                    Image ("contextmarkright")
                                }
                                .padding(4)
                            }
                            .padding()
                            .background(.contextquote)
                            .cornerRadius(28)
                            .padding(.top, 4)
                            
                            // Context
                            VStack (spacing: 20) {
                                
                                // Text
                                VStack (spacing: 0) {
                                    
                                    // Historical Context section
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Historical Context")
                                            .font(.custom("Helvetica Now Display Medium", size: 10))
                                            .hidden()
                                        
                                        VStack(alignment: .leading, spacing: 24) {
                                            Text(context.historicalContext)
                                                .font(.custom("Adobe Caslon Pro", size: 20))
                                                .multilineTextAlignment(.leading)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .lineSpacing(8)
                                        }
                                    }
                                    
                                    // Quote Breakdown section
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Quote Breakdown")
                                            .font(.custom("Helvetica Now Display Medium", size: 12))
                                            .hidden()
                                        
                                        VStack(alignment: .leading, spacing: 24) {
                                            Text(context.quoteBreakdown)
                                                .font(.custom("Adobe Caslon Pro", size: 20))
                                                .multilineTextAlignment(.leading)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .lineSpacing(8)
                                        }
                                    }
                                }
                                // Key Works section
                                if !context.keyWorks.isEmpty {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Key Work")
                                            .font(.custom("Helvetica Now Display XBold", size: 18))
                                            .underline()
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            ForEach(context.keyWorks, id: \.self) { work in
                                                Text("• \(work)")
                                                //                            .underline()
                                            }
                                            .font(.custom("Adobe Caslon Pro", size: 19))
                                            .multilineTextAlignment(.leading)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .lineSpacing(8)
                                            .padding(.leading)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding()
            // Footer at bottom
            ContextFooter(onDismiss: onDismiss)
        }
            // Only show BuyContext for free users after data is loaded
            if !subscriptionManager.isPremiumUser && !isLoading {
                BuyContext(onDismiss: onDismiss)
            }
    }
    }
}
    struct ContextFooter: View {
        var onDismiss: () -> Void

        var body: some View {
            ZStack {
            HStack (spacing: 6) {
                Spacer()
                HStack {
                    Button(action: {
                        
                    }) {
                        Image ("page")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .padding(EdgeInsets(top: 12, leading: 22, bottom: 12, trailing: 22))
                            .background(.contextgray)
                            .cornerRadius(26)
                    }
                    Button(action: {
                        
                    }) {
                        Image ("audio")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.contextgray)
                            .frame(width: 16, height: 16)
                            .padding(EdgeInsets(top: 12, leading: 22, bottom: 12, trailing: 22))
                            .background(.black)
                            .cornerRadius(26)
                    }
                }
                .padding(6)
                .background(.black)
                .cornerRadius(32)
                
                Button(action: {
                    
                }) {
                    Image ("contextheart")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.contextgray)
                        .frame(width: 16, height: 16)
                        .padding(16)
                        .foregroundStyle(.white)
                        .background(.black)
                        .clipShape(Ellipse())
                }
                Button(action: onDismiss) {
                    Image ("close")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.contextgray)
                        .frame(width: 20, height: 20)
                        .padding(15)
                        .background(.black)
                        .clipShape(Ellipse())
                }
            }
        }
            .padding(.horizontal)
//            .padding(.top)
            .padding(.bottom, -8)
            .background(.white)
            .frame(alignment: .bottom)
        }
    }

    

    
    // Helper function to format share text
    private func formatContextForSharing(_ context: QuoteContext) -> String {
        var shareText = "Quote: \"\(context.quote)\"\n"
        shareText += "Author: \(context.authorName)\n\n"
        
        if let birthYear = context.birthYear, let deathYear = context.deathYear {
            shareText += "Lifespan: \(birthYear) - \(deathYear)\n\n"
        } else if let birthYear = context.birthYear {
            shareText += "Born: \(birthYear)\n\n"
        }
        
        shareText += "Historical Context:\n\(context.historicalContext)\n\n"
        shareText += "What It Means:\n\(context.quoteBreakdown)\n\n"
        
        if !context.keyWorks.isEmpty {
            shareText += "Key Works:\n"
            for work in context.keyWorks {
                shareText += "• \(work)\n"
            }
        }
        
        return shareText
    }

// Add ShareSheet UIViewControllerRepresentable
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct GradientBackgroundView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.70, green: 0.90, blue: 0.95),  // Approximate color for the top
                    Color(red: 0.60, green: 0.85, blue: 0.75)   // Approximate color for the bottom
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            RadialGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.9), // Transparent white
                    Color.clear               // Fully transparent
                ]),
                center: .bottomLeading,
                startRadius: 5,
                endRadius: 400
            )
            .blendMode(.overlay)
            .edgesIgnoringSafeArea(.all)
        }
    }
}


#Preview {
    ContextView(
        context: QuoteContext(
            quote: "Stay hungry. Stay foolish.",
            authorName: "Steve Jobs",
            birthYear: "1955",
            deathYear: "2011",
            historicalContext: "This quote was said by Steve Jobs during his famous Stanford commencement speech in 2005. He was reflecting on his experiences and sharing life lessons with graduating students.",
            quoteBreakdown: "Jobs was encouraging graduates to maintain their curiosity and willingness to take risks, even when conventional wisdom suggests otherwise. The phrase originally came from the Whole Earth Catalog.",
            keyWorks: ["Apple Inc.", "Pixar Animation Studios", "Stanford Commencement Speech"]
        ),
        isLoading: false,
        onDismiss: {}
    )
}

//#Preview {
//    GradientBackgroundView()
//}
//
//// Preview for loading state
//#Preview {
//    ContextView(
//        context: nil,
//        isLoading: true,
//        onDismiss: {}
//    )
//}
