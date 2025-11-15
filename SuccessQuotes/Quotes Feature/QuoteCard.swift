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
    var isContextLoading: Bool = false  // Track if context is loading
    
    
    private let openAIService = OpenAIService()
    var showContext: (Quote) -> Void  // Add this line
    
    @State private var authorImage: UIImage? = nil
    @State private var isLoadingAuthorImage = true
    
    init(quote: Quote, isFilteredView: Bool = false, isContextLoading: Bool = false, showContext: @escaping (Quote) -> Void) {
        self.quote = quote
        self.isFilteredView = isFilteredView
        self.isContextLoading = isContextLoading
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
            
            // Track quote view with analytics
            AnalyticsManager.shared.trackQuoteViewed(quote: quote)
            AnalyticsManager.shared.trackAuthorPopularity(author: quote.author, interactionType: "viewed")
            AnalyticsManager.shared.trackTopicPopularity(topic: quote.topic, interactionType: "viewed")
            AnalyticsManager.shared.trackCategoryPopularity(category: quote.category, interactionType: "viewed")
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
                                if !isContextLoading {
                                    showContext(quote)
                                }
                            }) {
                                HStack(spacing: 3) {
                                    if isContextLoading {
                                        ProgressView()
                                            .scaleEffect(0.7)
                                    } else {
                                        Image(systemName: "lightbulb.max.fill")
                                    }
                                    Text("context")
                                }
                                .font(.callout)
                                .foregroundStyle(isContextLoading ? .gray : .black)
                            }
                            .disabled(isContextLoading)
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
                            .fullScreenCover(isPresented: $isCustomShareSheetPresented) {
                                NewShareSheet(quote: quote)
                            }
                            
                            
                            Button(action: {
                                isLocalFavorite.toggle()
                                quoteManager.toggleFavoriteWithAnalytics(for: quote.id)
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

}

// Simple preview-only card view
struct SimpleQuoteCardPreview: View {
    let quote: Quote
    
    var body: some View {
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
                Spacer()
            }
            
            Spacer()
            
            HStack {
                Text(quote.topic.uppercased())
                    .font(.custom("Helvetica", size: 12))
                    .foregroundColor(.black)
                Spacer()
                
                HStack {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.gray)
                    Image(systemName: "suit.heart")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.gray.opacity(0.1), radius: 10, x: 0, y: 1)
        .padding(.vertical)
    }
}

// For the preview
struct QuoteCard_Previews: PreviewProvider {
    static var previews: some View {
        SimpleQuoteCardPreview(
            quote: Quote(
                topic: "Inspiration", 
                quote: "The only way to do great work is to love what you do.", 
                author: "Steve Jobs", 
                category: "Business"
            )
        )
        .previewLayout(.sizeThatFits)
        .padding()
        .previewDisplayName("Quote Card")
    }
}
