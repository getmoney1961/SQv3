//
//  QuotesByCategoryView.swift
//  SuccessQuotes
//
//  Created by Barbara on 28/12/2024.
//

import SwiftUI

struct QuotesByCategoryView: View {
    let category: String
    @EnvironmentObject var quoteManager: QuoteManager
    
    var categoryQuotes: [Quote] {
        quoteManager.quotes.filter { $0.category == category }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(categoryQuotes) { quote in
                    NavigationLink(destination: FullScreenQuoteView(quote: quote)) {
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
                    }
                }
            }
            .padding()
        }
        .navigationTitle(category)
    }
}

#Preview {
    QuotesByCategoryView(category: "Motivation")
        .environmentObject(QuoteManager())
}
