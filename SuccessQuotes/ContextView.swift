//
//  ContextView.swift
//  SuccessQuotes
//
//  Created by Barbara on 28/11/2024.
//

import SwiftUI

struct ContextView: View {
    let context: String
    let isLoading: Bool
    var onDismiss: () -> Void
    @State private var isShareSheetPresented = false

    var body: some View {
        VStack(spacing: 16) {
            if isLoading {
                ProgressView("Loading context...")
                    .padding()

            } else {
                HStack {
                    Image(systemName: "lightbulb.max.fill")
                        .foregroundStyle(.black)
                        .opacity(0.5)
                    Text("Context")
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                    
                    Button(action: onDismiss) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.black)
                            .font(.system(size: 20))
                        //                        .padding(EdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14))
//                            .background(.white)
                            .cornerRadius(24)
                    }
                }
                    Text(context)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
//                Spacer()
                
                HStack {
                    
                    Button(action: {
                        isShareSheetPresented = true

                }) {
                    HStack {
                        Spacer()
                        Text("Share")
                        Image("share")
                            .resizable()
                            .frame(width: 14, height: 16)
                        Spacer()
                    }
                    .foregroundStyle(.white)
                    .padding(EdgeInsets(top: 14, leading: 20, bottom: 14, trailing: 20))
                    .background(.black.opacity(0.9))
                    .cornerRadius(24)
                }
                .sheet(isPresented: $isShareSheetPresented) {
                    ShareSheet(activityItems: [context])
                }
//                .padding()

//                    Spacer()

//                    Button(action: onDismiss) {
//                        Text("close")
//                            .foregroundColor(.black)
//                            .font(.system(size: 14))
//                            .padding(EdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14))
//                            .background(.white)
//                            .cornerRadius(24)
//                    }
                }
            }
        }
        .padding(24)
    }
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
        context: "This quote was said by Steve Jobs during his famous Stanford commencement speech in 2005. He was reflecting on his experiences and sharing life lessons with graduating students.",
        isLoading: false,
        onDismiss: {}  // Add empty closure for preview
    )
}

#Preview {
    GradientBackgroundView()
}

// Preview for loading state
#Preview {
    ContextView(
        context: "",
        isLoading: true,
        onDismiss: {}  // Add empty closure for preview
    )
}
