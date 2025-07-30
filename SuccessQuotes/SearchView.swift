//
//  SearchView.swift
//  SuccessQuotes
//
//  Created by Barbara on 24/10/2024.
//

import SwiftUI

struct SearchView: View {
    @State private var search: String = ""
    @FocusState private var isFocused: Bool // Correct usage of FocusState
    @Binding var focusSearchField: Bool // Trigger passed from ContentView
    @EnvironmentObject var quoteManager: QuoteManager
    
    @State private var selectedTopic: String?
    @State private var selectedQuote: Quote?
    
    var searchResults: [Quote] {
        quoteManager.searchQuotes(query: search)
    }
    
    var categories: [String] {
        let allCategories = quoteManager.quotes.map { $0.category }
        let uniqueCategories = Set(allCategories)
        return Array(uniqueCategories).sorted().filter { !$0.isEmpty && $0 != "Unknown" }
    }
    
    var filteredTopics: [String] {
        let lowercasedQuery = quoteManager.normalizeApostrophes(
            search.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        if lowercasedQuery.isEmpty {
            return []
        }
        return quoteManager.topics.filter { topic in
            let normalizedTopic = quoteManager.normalizeApostrophes(topic)
            return normalizedTopic.contains(lowercasedQuery)
        }
    }
    
    var body: some View {
//        NavigationView {
            ZStack {
                Color(red: 0.981, green: 0.976, blue: 0.976).ignoresSafeArea(.all)
                
                VStack (spacing: 8) {
                    VStack {
                        Text("Search")
                            .font(.custom("EditorialNew-Regular", size: 32))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 16, leading: 16, bottom: 4, trailing: 16))
                    HStack {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.black.opacity(0.5))
                            TextField("", text: $search, prompt: Text("Search quote, topic or author")
                                .foregroundColor(.black.opacity(0.5)))
                                .focused($isFocused) // Bind focus state to the TextField
                            
                            if !search.isEmpty {
                                Button(action: {
                                    search = "" // Clear the search text
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                                .transition(.opacity)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 36))
                        .padding(.bottom, 4)

                        // Clear button appears when search is not empty
                        
                        
                        if isFocused {
                            Button(action: {
                                withAnimation(.easeInOut) {
                                    search = "" // Clear the search text
                                    isFocused = false // Unfocus the text field
                                }
                            }) {
                                Text("Cancel")
                                    .foregroundColor(.black)
                                    .padding(.vertical)
                            }
                            .transition(.opacity)
                        }
                    }
                    .padding(.horizontal)
                    
                    ScrollView (/*showsIndicators: false*/) {
                        if search.isEmpty {
                            
                            VStack (alignment: .leading, spacing: 8) {
                                // Categories Section
                                Text("Categories")
                                    .font(.system(size: 12))
                                    .fontWeight(.bold)
                                    .textCase(.uppercase)
                                    .padding(.top, 24)
                                Divider()
                                    .padding(.bottom, 8)
                                
                                ForEach(0..<(categories.count + 1) / 2, id: \.self) { row in
                                    HStack(spacing: 8) {
                                        NavigationLink(destination: QuotesByCategoryView(category: categories[row * 2])) {
                                            CategoryCard(category: categories[row * 2])
                                        }
                                        
                                        if row * 2 + 1 < categories.count {
                                            NavigationLink(destination: QuotesByCategoryView(category: categories[row * 2 + 1])) {
                                                CategoryCard(category: categories[row * 2 + 1])
                                            }
                                        }
                                    }
                                    .frame(maxWidth: .infinity, minHeight: 250, alignment: .center)
                                }
                            
                                Text("Topics")
                                    .font(.system(size: 12))
                                    .fontWeight(.bold)
                                    .textCase(.uppercase)
                                    .padding(.top, 8)
                                Divider()
                                    .padding(.bottom, 8)

                                let topics = quoteManager.topics.filter { !$0.isEmpty }
                                ForEach(0..<(topics.count + 1) / 2, id: \.self) { row in
                                    HStack(spacing: 8) {
                                        // Left column
                                        NavigationLink(destination: QuotesByTopicView(topic: topics[row * 2])) {
                                            TopicCard(topic: topics[row * 2])
                                        }
                                        
                                        //                                Spacer(minLength: 2)
                                        // Right column (if exists)
                                        if row * 2 + 1 < topics.count {
                                            NavigationLink(destination: QuotesByTopicView(topic: topics[row * 2 + 1])) {
                                                TopicCard(topic: topics[row * 2 + 1])
                                            }
                                        } else {
                                            //                                    Spacer() // Empty space if odd number of topics
                                        }
                                    }
                                    .frame(maxWidth: .infinity, minHeight: 160, alignment: .center)
                                }
                                
                                //                    .padding(.horizontal)
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 16)
                            
                        } else {
                            // Search Results
                            LazyVStack(alignment: .leading, spacing: 8) {
                                // Topics Section (if any matches found)
                                if !filteredTopics.isEmpty {
                                    Text("Topics")
                                        .font(.system(size: 24))
                                        .fontWeight(.bold)
                                        .padding(.top)
                                    
                                    let columns = Array(stride(from: 0, to: filteredTopics.count, by: 2))
                                    ForEach(columns, id: \.self) { index in
                                        HStack(spacing: 8) {
                                            // Left column
                                            NavigationLink(destination: QuotesByTopicView(topic: filteredTopics[index])) {
                                                TopicCard(topic: filteredTopics[index])
                                            }
                                            
                                            // Right column (if exists)
                                            if index + 1 < filteredTopics.count {
                                                NavigationLink(destination: QuotesByTopicView(topic: filteredTopics[index + 1])) {
                                                    TopicCard(topic: filteredTopics[index + 1])
                                                }
                                            }
                                        }
                                        .frame(maxWidth: .infinity, minHeight: 100, alignment: .center)
                                    }
                                    
                                    // Divider between topics and quotes
                                    if !searchResults.isEmpty {
                                        Divider()
                                            .padding(.vertical)
                                    }
                                }
                                // Quotes Section (if any matches found)
                                if !searchResults.isEmpty {
                                    Text("Quotes")
                                        .font(.system(size: 24))
                                        .fontWeight(.bold)
                                    VStack {
                                    ForEach(searchResults) { quote in
                                        NavigationLink(destination: FullScreenQuoteView(quote: quote)) {
                                            VStack(alignment: .leading, spacing: 10) {
                                                
                                                Text(quote.quote)
                                                    .font(.custom("NewYork-Regular", size: 16))
                                                    .lineSpacing(5)
                                                    .foregroundColor(.black)
                                                    .multilineTextAlignment(.leading)
                                                    .padding(.bottom, 8)
                                                HStack {
                                                    Spacer()
                                                    Text(quote.author)
                                                        .font(.custom("NewYork-RegularItalic", size: 14))
                                                        .foregroundColor(.gray)
                                                        .multilineTextAlignment(.center)
                                                        .padding(.bottom, 4)
                                                    
                                                    Spacer()
                                                    
                                                }
                                                
                                                
                                                HStack {
                                                    Text("\(quote.topic)")
                                                        .font(.custom("Helvetica", size: 12))
                                                        .foregroundColor(.black)
                                                        .multilineTextAlignment(.leading)
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                    
                                                    Spacer()
                                                    
                                                    
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
                                        }
//                                        .padding(.bottom, -8)
                                    }
                                }
                                    .padding(.bottom)
                                }
                                // No results message
                                if filteredTopics.isEmpty && searchResults.isEmpty {
                                    Text("No results found")
                                        .foregroundColor(.gray)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .padding(.top)
                                }
                            }
                            //                    .padding(.bottom)
                            .padding(.horizontal)
                        }
                    }
                }
                .onAppear {
                    if focusSearchField {
                        isFocused = true
                    }
                }
                .onChange(of: focusSearchField) { newValue in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isFocused = newValue
                    }
                }
                .onChange(of: isFocused) { newValue in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        focusSearchField = newValue
                    }
                }
            }
//        }
}
}


#Preview {
    SearchView(focusSearchField: .constant(false))
        .environmentObject(QuoteManager())
}
