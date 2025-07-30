//
//  NewView.swift
//  SuccessQuotes
//
//  Created by Barbara on 08/12/208.
//

import SwiftUI

struct NewView: View {
    @State private var bgColor: Color = .white // Add state for bg color
    @State private var selectedFont: String = "NewYork-Regular"
    @State private var currentIndex: Int = 0  // Add this state variable

    let quote: Quote
    
    var body: some View {

//                ZStack {
//                    // MARK: - Background Color
//                    Color.black
//                        .edgesIgnoringSafeArea(.all) // Header background extends to the edges
//                    
//                    VStack(spacing: 0) {
//                        // MARK: - Header
//                        VStack(alignment: .leading) {
//                            Text("Home")
//                                .font(.largeTitle)
//                                .fontWeight(.bold)
//                                .foregroundColor(.white)
//                            
//                            Text("427 West Paces Ferry Rd")
//                                .font(.subheadline)
//                                .foregroundColor(.gray)
//                        }
//                        .padding(.top, 50) // Adjust header padding
//                        .padding(.horizontal)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .background(Color.black)
//                        
//                        // MARK: - Rounded Corner Content
//                        VStack {
//                            Spacer()
//                            // Sample content
//                            Text("Your profile is under construction")
//                                .font(.headline)
//                                .foregroundColor(.black)
//                            
//                            Spacer()
//                        }
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .background(Color.white) // Main content background
//                        .clipShape(RoundedCorner(radius: 30, corners: [.topLeft, .topRight]))
//                        .edgesIgnoringSafeArea(.bottom) // Allow content to flow
//                    }
//                }




//            Color.green.ignoresSafeArea(.all)
            
//            VStack {
//                CustomTest(quote: quote, currentIndex: $currentIndex)
//            }  // Pass the binding
//            .frame(height: 360)
        
        VStack {
            VStack (spacing: 8) {
                Text("\"\(quote.quote)\"")
                    .font(.custom(selectedFont, size: 16))
                    .multilineTextAlignment(.center)
                    .background(bgColor)
                Text("- \(quote.author)")  // Added dash with space
                    .font(.custom(selectedFont, size: 12))
                    .multilineTextAlignment(.center)
        }
            .padding()
            .background(bgColor)

            VStack (spacing: 0) {
                HStack{                // Font buttons
                    HStack(spacing: 12) {
                        Button(action: { selectedFont = "NewYork-Regular" }) {
                            Text("Aa")
                                .font(.custom("NewYork-Regular", size: 32))
                                .foregroundStyle(.black)
                                .frame(width: 50, height: 50)
//                                .background(selectedFont == "NewYork-Regular" ? .gray.opacity(0.1) : .clear)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedFont == "NewYork-Regular" ? .black.opacity(0.1) : .clear, lineWidth: 1)
                                )
                        }
                        
                        Button(action: { selectedFont = "Helvetica" }) {
                            Text("Aa")
                                .font(.custom("Helvetica", size: 32))
                                .foregroundStyle(.black)
                                .frame(width: 50, height: 50)
//                                .background(selectedFont == "Helvetica" ? .gray.opacity(0.1) : .clear)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedFont == "Helvetica" ? .black.opacity(0.1) : .clear, lineWidth: 1)
                                )
                        }
                        
                        Button(action: { selectedFont = "Georgia" }) {
                            Text("Aa")
                                .font(.custom("Georgia", size: 32))
                                .foregroundStyle(.black)
                                .frame(width: 50, height: 50)
//                                .background(selectedFont == "Georgia" ? .gray.opacity(0.1) : .clear)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedFont == "Georgia" ? .black.opacity(0.1) : .clear, lineWidth: 1)
                                )
                        }
                        
                        Button(action: { selectedFont = "Avenir" }) {
                            Text("Aa")
                                .font(.custom("Avenir", size: 32))
                                .foregroundStyle(.black)
                                .frame(width: 50, height: 50)
//                                .background(selectedFont == "Avenir" ? .gray.opacity(0.1) : .clear)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedFont == "Avenir" ? .black.opacity(0.1) : .clear, lineWidth: 1)
                                )
                        }
                        
                        Button(action: { selectedFont = "Palatino" }) {
                            Text("Aa")
                                .font(.custom("Palatino", size: 32))
                                .foregroundStyle(.black)
                                .frame(width: 50, height: 50)
//                                .background(selectedFont == "Palatino" ? .gray.opacity(0.1) : .clear)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedFont == "Palatino" ? .black.opacity(0.1) : .clear, lineWidth: 1)
                                )
                        }
                        
                        Button(action: { selectedFont = "Didot" }) {
                            Text("Aa")
                                .font(.custom("Didot", size: 32))
                                .foregroundStyle(.black)
                                .frame(width: 50, height: 50)
//                                .background(selectedFont == "Didot" ? .gray.opacity(0.1) : .clear)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedFont == "Didot" ? .black.opacity(0.1) : .clear, lineWidth: 1)
                                )
                        }
                    }
                    .padding()
                }
                
                HStack(spacing: 20) {
                    // Color buttons
                    ForEach([Color.white, .red, .blue, .green, .purple, .orange], id: \.self) { color in
                        Button(action: {
                            bgColor = color
                        }) {
                            Circle()
                                .fill(color)
                                .frame(width: 40, height: 40)
                        }
                    }
                }
                .padding()
            }
        }
    }
    struct Watermark: View {
        var body: some View {
            VStack (alignment: .trailing) {
                Text("S")
                    .font(.custom("NewYork-Regular", size: 64))
                    .foregroundStyle(.red)
                Text("Success Quotes")
                    .font(.custom("NewYork-Regular", size: 16))
                    .italic()

            }
        }
    }
    // MARK: - RoundedCorner Shape
    struct RoundedCorner: Shape {
        var radius: CGFloat
        var corners: UIRectCorner

        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(
                roundedRect: rect,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: radius, height: radius)
            )
            return Path(path.cgPath)
        }
    }
}

#Preview {
    NewView(                quote: Quote(
        topic: "Success",
        quote: "Try not to become a man of success, but rather try to become a man of value.",
        author: "Albert Einstein"
    ))
}
