//
//  FullScreenQuoteView.swift
//  SuccessQuotes
//
//  Created by Barbara on 17/11/2024.
//

import SwiftUI

struct FullScreenQuoteView: View {
    let quote: Quote  // Pass the quote object to this full-screen view
    @EnvironmentObject private var quoteManager: QuoteManager
    @State private var isLocalFavorite: Bool
    @State private var isCustomShareSheetPresented = false
    @State private var isShowingContext = false
    @State private var quoteContext: String = ""
    @State private var isLoadingContext = false
    private let openAIService = OpenAIService()
    @State private var isDefaultView = false // Add this state variable
    @State private var isMonoView = false // Add this state variable
    @State private var isBoldView = false // Add this state variable
    @State private var isGroovyView = false // Add this state variable
    @State private var isCorpView = false // Add this state variable
    @State private var isRegularView = false // Add this state variable

    init(quote: Quote) {
        self.quote = quote
        self._isLocalFavorite = State(initialValue: quote.isFavorite)
        self._isDefaultView = State(initialValue: true) // Set default view as initial state
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 32) {
            Spacer()
           
            ZStack {
                if isDefaultView {
                    Default(quote: quote)
                }
                if isMonoView {
                    Mono(quote: quote)
                }
                if isBoldView {
                    Bold(quote: quote)
                }
                if isGroovyView {
                    Groovy(quote: quote)
                }
                if isCorpView {
                    Corp(quote: quote)
                }
                if isRegularView {
                    Regular(quote: quote)
                }

            }//            HStack {
//                Text("\(quote.topic)")
//                    .font(.custom("Helvetica", size: 12))
//                    .foregroundColor(.gray)
//                    .textCase(.uppercase)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//
//                Spacer()
//
//        }
            HStack (spacing: 16) {
                Spacer()
//                Button(action: {
//                                   Task {
//                                       isLoadingContext = true
//                                       isShowingContext = true
//                                       do {
//                                           quoteContext = try await openAIService.getQuoteContext(quote: quote)
//                                       } catch {
//                                           quoteContext = "Failed to load context. Please try again."
//                                       }
//                                       isLoadingContext = false
//                                   }
//                }) {
//                    HStack(spacing: 3) {
//                        Image(systemName: "lightbulb.max.fill")
//                        Text("context")
//                    }
//                    .font(.callout)
//                    .foregroundStyle(.black)
//                }
                
            Button(action: {
                isCustomShareSheetPresented = true
            }) {
                Image("share")
                    .resizable()
                    .frame(width: 22, height: 24)
                    .foregroundColor(.gray)
            }
            .sheet(isPresented: $isCustomShareSheetPresented) {
                CustomShareSheet(quote: quote)
            }
            
            
            Button(action: {
                isLocalFavorite.toggle()
                quoteManager.toggleFavorite(for: quote.id)
            }) {
                Image(systemName: isLocalFavorite ? "suit.heart.fill" : "suit.heart")
                    .foregroundColor(isLocalFavorite ? .red : .gray)
            }
                Spacer()
        }
            .font(.system(size: 24, weight: .medium))
            Spacer()
            }
        .padding()
        .background(Color.white)
        .navigationBarTitleDisplayMode(.inline)
        .overlay {
            if isShowingContext {
                GeometryReader { geometry in
                    Color.black.opacity(0.7)
                        .ignoresSafeArea()
                        .onTapGesture {
                            isShowingContext = false
                        }
                    
                    ContextView(
                        context: quoteContext,
                        isLoading: isLoadingContext,
                        onDismiss: { isShowingContext = false }
                    )
                    .frame(width: UIScreen.main.bounds.width - 40)
                    .background(.bg)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding()
                    .transition(.scale)
                    .animation(.spring(), value: isShowingContext)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
                .ignoresSafeArea()
            }
        }
        
//        Default //
        HStack {
            Button(action: {
                resetViews()
                isDefaultView = true
            }) {
                Text("Aa")
                    .font(.custom("NewYork-Regular", size: 24)) // Using buttonFont directly
                    .frame(width: 100, height: 100)
                    .background(.white)
                    .foregroundColor(.black)
                    .cornerRadius(24)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(isDefaultView ? .black.opacity(0.9) : .clear, lineWidth: 2)
                    )
            }
            
            
//            Mono //
            Button(action: {
                resetViews()
                isMonoView = true
            }) {
                Text("Aa")
                    .font(.custom("Courier", size: 24)) // Using buttonFont directly
                    .frame(width: 100, height: 100)
                    .background(.yellow.opacity(0.1))
                    .foregroundColor(.black)
                    .cornerRadius(24)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(isMonoView ? .black.opacity(0.9) : .clear, lineWidth: 2)
                    )
            }
            
//            Bold //
            Button(action: {
                resetViews()
                isBoldView = true
            }) {
                Text("Aa")
                    .font(.custom("Helvetica Neue Bold", size: 24)) // Using buttonFont directly
                    .frame(width: 100, height: 100)
                    .background(.black.opacity(0.9))
                    .foregroundColor(.bg)
                    .cornerRadius(24)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(isBoldView ? .gray : .clear, lineWidth: 2)
                    )
            }
        }
        
        HStack {
// Groovy //
            Button(action: {
                resetViews()
                isGroovyView = true
            }) {
                Text("Aa")
                    .font(.custom("Times New Roman", size: 24)) // Using buttonFont directly
                    .frame(width: 100, height: 100)
                    .background(.black)
                    .foregroundColor(.white)
                    .cornerRadius(24)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(isGroovyView ? .gray : .clear, lineWidth: 2)
                    )
            }
            
//            Corp //
            Button(action: {
                resetViews()
                isCorpView = true
            }) {
                Text("Aa")
                    .font(.system(size: 24)) // Using buttonFont directly
                    .frame(width: 100, height: 100)
                    .background(.blue.opacity(0.1))
                    .foregroundColor(.black)
                    .cornerRadius(24)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(isCorpView ? .black.opacity(0.9) : .clear, lineWidth: 2)
                    )
            }
            
//            Regular //
            Button(action: {
                resetViews()
                isRegularView = true
            }) {
                Text("Aa")
                    .font(.custom("EditorialNew-Regular", size: 24)) // Using buttonFont directly
                    .frame(width: 100, height: 100)
                    .background(.black.opacity(0.9))
                    .foregroundColor(.white)
                    .cornerRadius(24)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(isRegularView ? .gray : .clear, lineWidth: 2)
                    )
            }
        }
    }
    private func resetViews() {
        isDefaultView = false
        isMonoView = false
        isBoldView = false
        isGroovyView = false
        isCorpView = false
        isRegularView = false
    }
}

struct Regular: View {
    let quote: Quote

    var body: some View {
        ZStack {
        VStack {
            Spacer()
            VStack (alignment: .center, spacing: 16) {
                Text(quote.quote)
                    .foregroundStyle(.white)
                    .font(.custom("EditorialNew-Regular", size: 20))
                    .multilineTextAlignment(.center)
                Text("- \(quote.author)")  // Added dash with space
                    .foregroundStyle(.white)
                    .font(.custom("EditorialNew-Regular", size: 12))
                    .multilineTextAlignment(.center)
            }
            Spacer()
        }
    }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(red: 25/255, green: 25/255, blue: 25/255))
    }
}


struct Corp: View {
    let quote: Quote

    var body: some View {
        ZStack {
        VStack {
            Spacer()
            VStack (alignment: .center, spacing: 16) {
                Text(quote.quote)
                    .font(.system(size: 18))
                    .multilineTextAlignment(.center)
                Text("- \(quote.author)")
                    .font(.system(size: 12))
            }
            Spacer()
        }
    }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(red: 229/255, green: 241/255, blue: 255/255))
        }
}


struct Groovy: View {
    let quote: Quote

    var body: some View {
        ZStack {
        VStack {
            Spacer()
            VStack (alignment: .center, spacing: 16) {
                Text(quote.quote)
                    .foregroundStyle(.white)
                    .font(.custom("Times New Roman", size: 20))
                    .multilineTextAlignment(.center)
                Text("- \(quote.author)")
                    .foregroundStyle(.white)
                    .font(.custom("Times New Roman", size: 12))
                    .multilineTextAlignment(.center)
            }
            Spacer()
        }
    }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.black)
    }

    }

struct Bold: View {
    let quote: Quote

    var body: some View {
        ZStack {
        VStack {
            Spacer()
            HStack {
                VStack (alignment: .leading, spacing: 16) {
                    Text(quote.quote)
                        .foregroundStyle(.white)
                        .font(.custom("Helvetica Neue Bold", size: 50))
                        .multilineTextAlignment(.leading)
                    Text("- \(quote.author)")
                        .foregroundStyle(.white)
                        .font(.custom("Helvetica Neue", size: 12))
                        .multilineTextAlignment(.leading)
                }
                Spacer()
            }
        }
    }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(red: 25/255, green: 25/255, blue: 25/255))
    }

}

struct Mono: View {
    let quote: Quote
    
    var body: some View {
        ZStack{
        VStack {
            VStack (alignment: .leading, spacing: 16) {
                Text(quote.quote)
                    .foregroundStyle(.black)
                    .font(.custom("Courier", size: 20))
                Spacer()
                HStack(alignment: .lastTextBaseline) {
                    Text(quote.author)
                        .font(.custom("Courier", size: 12))
                        .textCase(.uppercase)
                    Spacer()
                }
            }
        }
    }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(red: 255/255, green: 250/255, blue: 229/255))

    }
}

struct Default: View {
    let quote: Quote
    
    var body: some View {
        ZStack {
            VStack {
                VStack (alignment: .center, spacing: 32) {
                    Spacer()
                    Text(quote.quote)
                                    .font(.custom("NewYork-Regular", size: 24))
                                    .lineSpacing(5)
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true) // Ensure it expands vertically
                                Text("- \(quote.author)")
                                    .font(.custom("NewYork-RegularItalic", size: 14))
                                    .foregroundColor(.gray)
                    Spacer()
                }
            }

        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.white)
    }
}

#Preview {
    FullScreenQuoteView(quote: Quote(topic: "Preview",
                                   quote: "The only way to do great work is to love what you do.",
                                   author: "Steve Jobs"))
        .environmentObject(QuoteManager())
}
