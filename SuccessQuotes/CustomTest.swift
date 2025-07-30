//
//  CustomTest.swift
//  SuccessQuotes
//
//  Created by Barbara on 07/12/2024.
//

import SwiftUI

struct CustomTest: View {
    let quote: Quote
    @Binding var currentIndex: Int  // Change from @State to @Binding
    @GestureState private var dragOffset: CGFloat = 0
    
    var body: some View {
        
        VStack() {
                 TabView(selection: $currentIndex) {
                     Default(quote: quote)
                         .tag(0)
                     
                     Regular(quote: quote)
                         .tag(1)
                 }
                 .tabViewStyle(.page(indexDisplayMode: .never)) // Hide default indicators
                 
                 // Custom page indicators
                 HStack(spacing: 10) {
                     ForEach(0..<2) { index in
                         Circle()
                             .fill(currentIndex == index ? Color.black : Color.gray)
                             .frame(width: 8, height: 8)
                     }
                 }
                 .padding(.bottom, 20)
             }
//        ZStack {
//            Color.yellow.opacity(0.1).ignoresSafeArea()
//            GeometryReader { proxy in
//                let size = proxy.size
//                
//                HStack(spacing: 0) {
//                    ForEach(0..<6) { index in
//                        Group {
//                            switch index {
//                            case 0: Default(quote: quote)
//                            case 1: Mono(quote: quote)
//                            case 2: Bold(quote: quote)
//                            case 3: Groovy(quote: quote)
//                            case 4: Corp(quote: quote)
//                            case 5: Regular(quote: quote)
//                            default: EmptyView()
//                            }
//                        }
//                        .frame(width: size.width - 0)
//                    }
//                }
//                .offset(x: -CGFloat(currentIndex) * (size.width - 0) + dragOffset)
//                .gesture(
//                     DragGesture()
//                         .updating($dragOffset) { value, state, _ in
//                             state = value.translation.width
//                         }
//                         .onEnded { value in
//                             let threshold = size.width * 0.15 // Reduced threshold for easier swipe
//                             let velocity = value.predictedEndLocation.x - value.location.x
//                             var newIndex = currentIndex
//                             
//                             // Consider both position and velocity for more natural swipes
//                             if (value.translation.width < -threshold || velocity < -500) && currentIndex < 5 {
//                                 newIndex += 1
//                             } else if (value.translation.width > threshold || velocity > 500) && currentIndex > 0 {
//                                 newIndex -= 1
//                             }
//                             
//                             withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
//                                 currentIndex = newIndex
//                             }
//                         }
//                 )
//                 .animation(.interactiveSpring(response: 0.3, dampingFraction: 0.8), value: dragOffset)
//             }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Use maximum available space
//            .padding(.horizontal)
            
            // Optional: Add page indicators
//            VStack {
//                Spacer()
//                HStack(spacing: 10) {
//                    ForEach(0..<6) { index in
//                        Circle()
//                            .fill(currentIndex == index ? Color.black : Color.gray)
//                            .frame(width: 8, height: 8)
//                    }
//                }
//                .padding(.bottom, 20)
//            }
//        }
    }
}

//
//struct Regular: View {
//    let quote: Quote
//
//    var body: some View {
//        ZStack {
//        VStack {
//            Spacer()
//            VStack (alignment: .center, spacing: 16) {
//                Text(quote.quote)
//                    .foregroundStyle(.white)
//                    .font(.custom("Times New Roman", size: 20))
//                    .multilineTextAlignment(.center)
//                Text("- \(quote.author)")  // Added dash with space
//                    .foregroundStyle(.white)
//                    .font(.custom("Times New Roman", size: 12))
//                    .multilineTextAlignment(.center)
//            }
//            Spacer()
//        }
//        HStack {
//            Spacer()
//            Watermark()
//        }
//        .frame(maxHeight: .infinity, alignment: .bottom)
//    }
//            .padding()
//            .background(.black)
////            .frame(maxWidth: .infinity, maxHeight: 360)
//    }
//    struct Watermark: View {
//        var body: some View {
//            VStack (alignment: .trailing) {
//                Text("S")
//                    .font(.custom("NewYork-Regular", size: 32))
//                    .foregroundStyle(.red)
//                Text("Success Quotes")
//                    .font(.custom("NewYork-Regular", size: 8))
//                    .italic()
//                    .foregroundStyle(.white)
//            }
//        }
//    }
//}
//
//
//struct Corp: View {
//    let quote: Quote
//
//    var body: some View {
//        ZStack {
//        VStack {
//            Spacer()
//            VStack (alignment: .center, spacing: 16) {
//                Text("\"\(quote.quote)\"")
//                    .font(.system(size: 18))
//                    .multilineTextAlignment(.center)
//                Text("- \(quote.author)")
//                    .font(.system(size: 12))
//            }
//            Spacer()
//        }
//        HStack {
//            Spacer()
//            Watermark()
//        }
//        .frame(maxHeight: .infinity, alignment: .bottom)
//    }
//            .padding()
//            .background(Color(red: 229/255, green: 241/255, blue: 255/255))
////            .frame(maxWidth: .infinity, maxHeight: 360)
//        }
//
//    struct Watermark: View {
//        var body: some View {
//            VStack (alignment: .trailing) {
//                Text("S")
//                    .font(.custom("NewYork-Regular", size: 32))
//                    .foregroundStyle(.red)
//                Text("Success Quotes")
//                    .font(.custom("NewYork-Regular", size: 8))
//                    .italic()
//            }
//        }
//    }
//}
//
//
//struct Groovy: View {
//    let quote: Quote
//
//    var body: some View {
//        ZStack {
//        VStack {
//            Spacer()
//            VStack (alignment: .center, spacing: 16) {
//                Text("\"\(quote.quote)\"")
//                    .foregroundStyle(.white)
//                    .font(.custom("EditorialNew-Regular", size: 20))
//                    .multilineTextAlignment(.center)
//                Text("- \(quote.author)")
//                    .foregroundStyle(.white)
//                    .font(.custom("EditorialNew-Regular", size: 12))
//                    .multilineTextAlignment(.center)
//            }
//            Spacer()
//        }
//        HStack {
//            Spacer()
//            Watermark()
//        }
//        .frame(maxHeight: .infinity, alignment: .bottom)
//    }
//        .padding()
//        .background(Color(red: 25/255, green: 25/255, blue: 25/255))
////        .frame(maxWidth: .infinity, maxHeight: 360)
//    }
//    
//    struct Watermark: View {
//        var body: some View {
//            VStack (alignment: .trailing) {
//                Text("S")
//                    .font(.custom("NewYork-Regular", size: 32))
//                    .foregroundStyle(.red)
//                Text("Success Quotes")
//                    .font(.custom("NewYork-Regular", size: 8))
//                    .italic()
//                    .foregroundStyle(.white)
//            }
//        }
//    }
//
//    }
//
//struct Bold: View {
//    let quote: Quote
//
//    var body: some View {
//        ZStack {
//        VStack {
//            Spacer()
//            VStack (alignment: .center, spacing: 16) {
//                Text("\"\(quote.quote)\"")            .foregroundStyle(.black)
//                    .font(.custom("Helvetica Neue", size: 20))
//                    .multilineTextAlignment(.center)
//                Text("- \(quote.author)")
//                    .font(.custom("Helvetica Neue", size: 12))
//                    .multilineTextAlignment(.center)
//            }
//            Spacer()
//        }
//        HStack {
//            Spacer()
//            Watermark()
//        }
//        .frame(maxHeight: .infinity, alignment: .bottom)
//    }
//            .padding()
//            .background(Color(red: 225/255, green: 59/255, blue: 48/255))
////            .frame(maxWidth: .infinity, maxHeight: 360)
//    }
//    
//    struct Watermark: View {
//        var body: some View {
//            VStack (alignment: .trailing) {
//                Text("S")
//                    .font(.custom("NewYork-Regular", size: 32))
//                    .foregroundStyle(.black)
//                Text("Success Quotes")
//                    .font(.custom("NewYork-Regular", size: 8))
//                    .italic()
//                    .foregroundStyle(.white)
//            }
//        }
//    }
//}
//
//struct Mono: View {
//    let quote: Quote
//    
//    var body: some View {
//        ZStack{
//        VStack {
//            VStack (alignment: .leading, spacing: 16) {
//                Text("\"\(quote.quote)\"")            .foregroundStyle(.black)
//                    .font(.custom("Courier", size: 20))
//                Spacer()
//                HStack(alignment: .lastTextBaseline) {
//                    Text(quote.author)
//                        .font(.custom("Courier", size: 12))
//                        .textCase(.uppercase)
//                    Spacer()
//                }
//            }
//            //            Spacer()
//        }
//        HStack {
//            Spacer()
//            Watermark()
//        }
//        .frame(maxHeight: .infinity, alignment: .bottom)
//    }
//        .padding()
//        .background(Color(red: 255/255, green: 250/255, blue: 229/255))
////        .frame(maxWidth: .infinity, maxHeight: 360)
////        .padding(.leading, 8)
//    }
//    struct Watermark: View {
//        var body: some View {
//            VStack (alignment: .trailing) {
//                Text("S")
//                    .font(.custom("NewYork-Regular", size: 32))
//                    .foregroundStyle(.red)
//                Text("Success Quotes")
//                    .font(.custom("NewYork-Regular", size: 8))
//                    .italic()
//
//            }
//        }
//    }
//}
//
//struct Default: View {
//    let quote: Quote
//
//    var body: some View {
//        ZStack {
//        VStack {
//            Spacer()
//            VStack (alignment: .center, spacing: 16) {
//                Text(quote.quote)
//                    .foregroundStyle(.black)
//                    .font(.custom("NewYork-Regular", size: 20))
//                    .multilineTextAlignment(.center)
//                    .fixedSize(horizontal: false, vertical: true) // Ensure it expands vertically
//                Text("- \(quote.author)")
//                    .font(.custom("NewYork-Regular", size: 12))
//                    .multilineTextAlignment(.center)
//            }
////            .background(.yellow)
//            Spacer()
//        }
////        .background(.blue)
//            HStack {
//                Spacer()
//                Watermark()
//            }
//            .frame(maxHeight: .infinity, alignment: .bottom)
//    }
//            .padding()
//            .background(.white)
////            .frame(maxWidth: .infinity, maxHeight: 360)
//        
////            Spacer()
//        }
//    
//    struct Watermark: View {
//        var body: some View {
//            VStack (alignment: .trailing) {
//                Text("S")
//                    .font(.custom("NewYork-RegularItalic", size: 32))
//                    .foregroundStyle(.red)
//                Text("Success Quotes")
//                    .font(.custom("NewYork-Regular", size: 8))
//                    .italic()
//
//            }
//        }
//    }
//}

#Preview {
    // Create a wrapper view to provide the binding
    struct PreviewWrapper: View {
        @State private var currentIndex: Int = 0
        
        var body: some View {
            CustomTest(
                quote: Quote(
                    topic: "Success",
                    quote: "Try not to become a man of success, but rather try to become a man of value.",
                    author: "Albert Einstein"
                ),
                currentIndex: $currentIndex
            )
        }
    }
    
    return PreviewWrapper()
}
