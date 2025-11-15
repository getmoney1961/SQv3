//
//  Customisation.swift
//  SuccessQuotes
//
//  Created by Barbara on 07/12/2024.
//

import SwiftUI

struct Customisation: View {
    @State private var selectedTheme: Int = 0
    @State private var sampleText = "The quick brown fox jumped over the dog!"
    let quote: Quote  // Add quote property
    @State private var showCurlyQuotes = true  // Add this state variable
    
    var formattedQuote: String {
          showCurlyQuotes ? "\"\(quote.quote)\"" : quote.quote
      }
    
    let themes: [ThemeStyle] = [
        ThemeStyle(
            background: .white,
            foreground: .black,
            buttonFont: .custom("NewYork-Regular", size: 24),
            quoteText: .custom("NewYork-Regular", size: 24),
            authorText: .custom("NewYork-Regular", size: 12)
        ),
        ThemeStyle(
            background: .yellow.opacity(0.1),
            foreground: .black,
            buttonFont: .custom("Courier", size: 24),
            quoteText: .custom("Courier", size: 21),
            authorText: .custom("Courier", size: 12)
        ),
        ThemeStyle(
            background: .red,
            foreground: .black,
            buttonFont: .custom("Helvetica Neue", size: 24),
            quoteText: .custom("Helvetica Neue", size: 24),
            authorText: .custom("Helvetica Neue", size: 12)
        ),
        ThemeStyle(
            background: .black.opacity(0.9),
            foreground: .white,
            buttonFont: .custom("EditorialNew-Regular", size: 24),
            quoteText: .custom("EditorialNew-Regular", size: 24),
            authorText: .custom("EditorialNew-Regular", size: 12)
        ),
        ThemeStyle(
            background: .blue.opacity(0.1),
            foreground: .black,
            buttonFont: .system(size: 24),
            quoteText: .system(size: 21),
            authorText: .system(size: 12)
        ),
        ThemeStyle(
            background: .black,
            foreground: .white,
            buttonFont: .custom("Times New Roman", size: 24),
            quoteText: .custom("Times New Roman", size: 24),
            authorText: .custom("Times New Roman", size: 12)
        )
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .center, spacing: 16) {
                Text(formattedQuote)
                    .font(themes[selectedTheme].quoteText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .fixedSize(horizontal: false, vertical: true)
                    .minimumScaleFactor(0.5)
                    .lineSpacing(8) // Consistent line spacing
                    .padding(.vertical, 8)
                
                Text("- \(quote.author)")
                    .font(themes[selectedTheme].authorText)
                    .foregroundColor(themes[selectedTheme].foreground.opacity(0.8))
                    .padding(.bottom, 8)
            }
            .frame(maxWidth: .infinity)
            .padding(24)
            .background(themes[selectedTheme].background)
            .foregroundColor(themes[selectedTheme].foreground)
            .cornerRadius(12)
        }
        .padding(.horizontal)
            
             LazyVGrid(columns: [
                 GridItem(.flexible()),
                 GridItem(.flexible()),
                 GridItem(.flexible())
             ], spacing: 15) {
                 ForEach(0..<6) { index in
                     Button(action: {
                         selectedTheme = index
                     }) {
                         Text("Aa")
                             .font(themes[index].buttonFont)  // Using buttonFont directly
                             .frame(width: 100, height: 100)
                             .background(themes[index].background)
                             .foregroundColor(themes[index].foreground)
                             .cornerRadius(24)
                             .overlay(
                                 RoundedRectangle(cornerRadius: 24)
                                    .stroke(selectedTheme == index ? .black.opacity(0.9) : .clear, lineWidth: 2)
                             )
                     }
                 }
             }
             .padding()
        // Add quote style toggle button
         Button(action: {
             showCurlyQuotes.toggle()
         }) {
             HStack(spacing: 8) {
                 Image(systemName: showCurlyQuotes ? "quote.bubble.fill" : "quote.bubble")
                 Text(showCurlyQuotes ? "Remove Quotes" : "Add Quotes")
             }
             .padding(.horizontal, 16)
             .padding(.vertical, 8)
             .background(Color.gray.opacity(0.1))
             .cornerRadius(8)
         }
         }
    }

struct ThemeStyle {
    let background: Color
    let foreground: Color
    let buttonFont: Font
    let quoteText: Font
    let authorText: Font
}

#Preview {
    Customisation(quote: Quote(
        topic: "Success",
        quote: "Try not to become a man of success, but rather try to become a man of value.",
        author: "Albert Einstein"))
}
