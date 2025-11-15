//
//  QuotesByTopicView.swift
//  SuccessQuotes
//
//  Created by Barbara on 08/11/2024.
//

import SwiftUI

struct QuotesByTopicView: View {
    let topic: String
    @EnvironmentObject var quoteManager: QuoteManager

    var body: some View {
        ScrollView(/*showsIndicators: false*/) {
            VStack {
            ForEach(quoteManager.quotes(for: topic)) { quote in
                NavigationLink (destination: FullScreenQuoteView(quote: quote)) {
                    TopicQuoteCard(quote: quote)
                }
            }
        }
            .padding(.horizontal)
            .padding(.bottom, 16)
        .navigationTitle(topic)
    }

    }
}

struct TopicQuoteCard: View {
    @EnvironmentObject var quoteManager: QuoteManager
    @State private var isCustomShareSheetPresented = false
    @State private var isLocalFavorite: Bool

    let quote: Quote  // Pass the quote object to the view
    
    init(quote: Quote) {
        self.quote = quote
        self._isLocalFavorite = State(initialValue: quote.isFavorite)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(quote.quote)
                .font(.custom("NewYork-Regular", size: 16))
                .lineSpacing(5)
                .foregroundColor(.black)
//                .lineLimit(2)
                .multilineTextAlignment(.center)
                .padding(.bottom, 8)
            
                Text(quote.author)
                    .font(.custom("NewYork-RegularItalic", size: 14))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 4)
            
            HStack {
                Text(quote.topic)
                    .font(.custom("Helvetica", size: 12))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.gray.opacity(0.1), radius: 10, x: 0, y: 1)
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
}


struct QuotesByTopicView_Previews: PreviewProvider {
    static var previews: some View {
        let mockQuoteManager = QuoteManager()
        mockQuoteManager.quotes = [
            Quote(topic: "Inspiration", quote: "The only way to do great work is to love what you do.", author: "Steve Jobs"),
            Quote(topic: "Inspiration", quote: "Success is not the key to happiness. Happiness is the key to success.", author: "Albert Schweitzer")
        ]
        
        return QuotesByTopicView(topic: "Inspiration")
            .environmentObject(mockQuoteManager)
            .previewLayout(.sizeThatFits)
    }
}
