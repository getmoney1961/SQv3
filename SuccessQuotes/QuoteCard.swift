//
//  QuoteCard.swift
//  SuccessQuotes
//
//  Created by Barbara on 16/10/2024.
//

import SwiftUI
import UIKit
import Photos

struct QuoteCard: View {
    @EnvironmentObject var quoteManager: QuoteManager
    @State private var isCustomShareSheetPresented = false
    @State private var isLocalFavorite: Bool
    @State private var isFlipped = false
    @State private var rotation: Double = 0

    let quote: Quote  // Pass the quote object to the view
    var isFilteredView: Bool = false  // Add this parameter
    
    @State private var contextText = ""
    @State private var isLoadingContext = true
    
    private let openAIService = OpenAIService()
    var showContext: (Quote) -> Void  // Add this line
    
    @State private var authorImage: UIImage? = nil
    @State private var isLoadingAuthorImage = true
    
    init(quote: Quote, isFilteredView: Bool = false, showContext: @escaping (Quote) -> Void) {
        self.quote = quote
        self.isFilteredView = isFilteredView
        self.showContext = showContext
        self._isLocalFavorite = State(initialValue: quote.isFavorite)
    }
    var body: some View {
        ZStack {
              // Front of card
              cardFront
//                  .rotation3DEffect(
//                      .degrees(rotation),
//                      axis: (x: 0.0, y: 1.0, z: 0.0)
//                  )
//                  .opacity(isFlipped ? 0 : 1)

              // Back of card
//              cardBack
//                  .rotation3DEffect(
//                      .degrees(rotation + 180),
//                      axis: (x: 0.0, y: 1.0, z: 0.0)
//                  )
//                  .opacity(isFlipped ? 1 : 0)
          }
        .onChange(of: quote.id) { _ in
            // Immediately reset flip state and rotation when quote changes
            isFlipped = false
            rotation = 0
        }
          .onTapGesture {
              // Only allow flipping if not in filtered view
              if !isFilteredView {
                  withAnimation(.easeInOut(duration: 0.5)) {
                      rotation += 180
                      isFlipped.toggle()
                  }
              }
          }
        .onChange(of: quote.isFavorite) { newValue in
              isLocalFavorite = newValue
          }
        .onAppear {
            // Ensure local state is synced with QuoteManager when view appears
            if let updatedQuote = quoteManager.quotes.first(where: { $0.id == quote.id }) {
                isLocalFavorite = updatedQuote.isFavorite
            }
        }
    }
    
    // Move existing card content to a computed property
    private var cardFront: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack {
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text(quote.quote)
                        .font(.custom("NewYork-Regular", size: 16))
                        .lineSpacing(5)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        Text(quote.author)
                            .font(.custom("NewYork-Regular", size: 14))
                            .foregroundColor(.gray)
                            .onTapGesture {
                                quoteManager.filterByAuthor(quote.author)
                            }
                        Spacer()
                        if !isFilteredView {  // Modified condition
                            Button(action: {
//                                showContext(quote)  // Replace the context logic with this
                            }) {
                                HStack(spacing: 3) {
                                    Image(systemName: "lightbulb.max.fill")
                                    Text("context")
                                }
                                .font(.callout)
                                .foregroundStyle(.black)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    HStack {
                        Text("\(quote.topic)")
                            .font(.custom("Helvetica", size: 12))
                            .foregroundColor(.black)
                            .textCase(.uppercase)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .onTapGesture {
                                quoteManager.filterByTopic(quote.topic)
                            }
                        
                        Spacer()
                        
                        HStack {
                            Button(action: {
                                isCustomShareSheetPresented = true
                            }) {
                                Image("share")
                                    .resizable()
                                    .frame(width: 14, height: 16)
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
                                    .font(.system(size: 16, weight: .medium))
                            }
                        }
                    }
                }
                .padding(24)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(Color.white) // Add this to ensure the entire card is tappable
                .clipShape(RoundedRectangle(cornerRadius: 24))
                //            .overlay(
                //                RoundedRectangle(cornerRadius: 24)
                //                    .stroke(.gray.opacity(0.05), lineWidth: 2)
                //            )
                .shadow(color: Color.gray.opacity(0.1), radius: 10, x: 0, y: 1)
                .padding(.vertical)
//                .overlay (
//                    Group {
//                    if let quoteOfTheDay = quoteManager.quoteOfTheDay?.quote,
//                       quote.id == quoteOfTheDay.id {
//                        VStack {
//                            Spacer()
//                            HStack(alignment: .top) {
//                                Image("sq")
//                                    .resizable()
//                                    .frame(width: 64, height: 64)
//                                    .cornerRadius(8)
//                                VStack(alignment: .leading) {
//                                    Text(quote.author)
//                                        .fontWeight(.bold)
//                                        .foregroundColor(.white)
//                                    Text("Wiki Bio")
//                                        .foregroundColor(.white)
//                                }
//                                Spacer()
//                            }
//                            .padding(24)
//                            .frame(maxWidth: .infinity)
//                            .background(Color.blue)
//                            .cornerRadius(24)
//                        }
//                        .padding()
//                    }
//                    }
//                        .offset(x: 0, y: 50),
//                    alignment: .top
//                )
                
            }
            

        }
    }

    // Add new back side content
    private var cardBack: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack {
                VStack(alignment: .leading, spacing: 10) {
                    
                    ContextView(
                        context: contextText,
                        isLoading: isLoadingContext,
                        onDismiss: {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                rotation += 180
                                isFlipped.toggle()
                            }
                        }
                    )            // Add any other content you want on the back
                }
            }

        }
        .frame(maxWidth: .infinity, alignment: .center)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.gray.opacity(0.1), radius: 10, x: 0, y: 1)
        .padding(.vertical)
        .onChange(of: isFlipped) { newValue in
            if newValue {
                Task {
                    isLoadingContext = true
                    do {
                        contextText = try await openAIService.getQuoteContext(quote: quote)
                    } catch {
                        contextText = "Failed to load context. Please try again."
                    }
                    isLoadingContext = false
                }
            }
        }
    }
}

// For the preview
struct QuoteCard_Previews: PreviewProvider {
    static var previews: some View {
        QuoteCard(
            quote: Quote(topic: "Inspiration", quote: "The only way to do great work is to love what you do.", author: "Steve Jobs"),
            showContext: { _ in }  // Add empty closure for preview
        )
        .environmentObject(QuoteManager())
    }
}
