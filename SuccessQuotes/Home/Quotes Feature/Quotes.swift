//
//  Quotes.swift
//  SuccessQuotes
//
//  Created by Barbara on 19/10/2024.
//

import SwiftUI

struct Quotes: View {
    @EnvironmentObject private var quoteManager: QuoteManager
    @EnvironmentObject private var subscriptionManager: SubscriptionManager
    @State private var offset: CGFloat = 0
    @State private var isDragging = false
    @State private var dragDirection: CGFloat = 0
    @State private var showFilteredView = false
    @State private var isSearching = false
    @State private var searchText = ""
    @FocusState private var searchIsFocused: Bool
    @State private var showNotificationSettings = false  // Add state for notification settings sheet
    @Binding var showSideBar: Bool  // Add this line
    var showContext: (Quote) -> Void  // Add this line
    var isContextLoading: Bool = false  // Track context loading state
    
    // Computed property for accessible quotes based on premium status
    private var accessibleQuotes: [Quote] {
        return quoteManager.getAccessibleQuotes(isPremiumUser: subscriptionManager.isPremiumUser)
    }
    
    private var maxQuoteIndex: Int {
        return accessibleQuotes.count - 1
    }
    
    var body: some View {
        NavigationView {
            ZStack {
//                Color(red: 0.981, green: 0.976, blue: 0.976).ignoresSafeArea(.all)

//                Color.yellow.ignoresSafeArea(.all)
            VStack {
                
                if let filteredQuotes = quoteManager.filteredQuotes {
                    // Add this VStack for the filtered view
                    VStack {
                        HStack{
                            HStack {
                                switch quoteManager.filterType {
                                case .author(let author):
                                    Text("\(author)")
                                        .font(.system(size: 14))
                                        .foregroundStyle(.white)
                                case .topic(let topic):
                                    Text("\(topic)")
                                        .font(.system(size: 14))
                                        .foregroundStyle(.white)
                                case .none:
                                    EmptyView()
                                }
                                
                                //                            Spacer()
                                
                                Button(action: {
                                    quoteManager.clearFilter()
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.white)
                                        .font(.title2)
                                }
                            }
                            .padding(.leading, 4)
                            .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                            .background(.black.opacity(0.9))
                            .cornerRadius(32)
                            .padding(.top)
                            .padding(.horizontal)
                            Spacer()
                        }
                        
                        
                        ScrollView {
                            LazyVStack {
                                ForEach(filteredQuotes) { quote in
                                    NavigationLink(destination: FullScreenQuoteView(quote: quote)) {
                                        QuoteCard(quote: quote, isFilteredView: true, isContextLoading: false, showContext: { _ in })
                                            .padding(.horizontal, 8)
                                            .padding(.bottom, -32)
                                    }
                                }
                            }
                            .padding(.bottom)
                        }
                    }
                } else {
                    if accessibleQuotes.isEmpty {
                        ProgressView("Loading quotes...")
                    } else {
                        VStack {
                            HStack {
                                Text("Discover")
                                    .font(.custom("EditorialNew-Regular", size: 32))
                                    .foregroundColor(.black)
                                    .lineLimit(1)
                                Spacer()
                                Button(action: {
                                    showNotificationSettings = true
                                }) {
                                    Image(systemName: "bell")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .padding(8)
                                        .foregroundStyle(.black.opacity(1))
                                }
                                Button(action: {
                                    showSideBar = true
                                }) {
                                    Image("pro")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .padding(8)
                                        .foregroundStyle(.gray.opacity(0.7))
                                        .background(.gray.opacity(0.15))
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle()
                                                .stroke(.gray.opacity(0.2), lineWidth: 1)
                                        )
                                }
                                
                            }
                            .padding()
                            
                            ZStack {
                                
                                // Previous card (only visible when dragging right)
                                if quoteManager.currentQuoteIndex > 0 && offset > 0 {
                                    QuoteCard(quote: accessibleQuotes[quoteManager.currentQuoteIndex - 1], isContextLoading: false, showContext: { _ in })
                                        .padding()
                                        .zIndex(1)
                                    //                                    .opacity(min(1, offset / 100))
                                }
                                
                                ForEach(0..<min(2, accessibleQuotes.count - quoteManager.currentQuoteIndex), id: \.self) { index in
                                    VStack {
                                    QuoteCard(
                                        quote: accessibleQuotes[quoteManager.currentQuoteIndex + index],
                                        isContextLoading: isContextLoading && index == 0,  // Only show loading on current card
                                        showContext: showContext  // Pass the closure down
                                    )
                                    .padding()
                                    .overlay(
                                        Group {
                                            if index == 0 && quoteManager.currentQuoteIndex == 0 {
                                                HStack{
                                                    Text("Quote of the Day")
                                                        .font(.caption)
                                                        .padding(5)
                                                        .background(Color.yellow.opacity(0.8))
                                                        .cornerRadius(5)
                                                }
                                            }
                                        }
                                            .offset(x: 0, y: -10),
                                        alignment: .top
                                    )
                                    .zIndex(Double(3 - index))
                                    .offset(x: index == 0 ? offset : 0, y: CGFloat(index) * 11)
                                    .rotationEffect(.degrees(index == 0 ? Double(offset / 10) : 0))
                                    .opacity(index == 1 && offset > 0 ? 0 : 1)
                                    //
                                    
//                                        if index == 0 && quoteManager.currentQuoteIndex == 0 {
//                                            AuthorBio(authorName: quoteManager.quotes[quoteManager.currentQuoteIndex + index].author)
//                                        }
                            }
                                    .zIndex(Double(3 - index))
                            .offset(x: index == 0 ? offset : 0, y: CGFloat(index) * 1)
                            .rotationEffect(.degrees(index == 0 ? Double(offset / 10) : 0))
//                            .padding(.bottom)
                                    //                                    .padding(.bottom)
                                    //                                    .padding(.horizontal)
                                }
                            }
                            .highPriorityGesture (
                                DragGesture()
                                    .onChanged { value in
                                        // Only respond to drags that start away from the left edge
                                        if value.startLocation.x >= 50 {
                                            isDragging = true
                                            offset = value.translation.width
                                            dragDirection = value.translation.width
                                        }
                                    }
                                    .onEnded { value in
                                        // Only process the gesture if it started away from the left edge
                                        if value.startLocation.x >= 50 {
                                            isDragging = false
                                            let swipeThreshold: CGFloat = UIScreen.main.bounds.width * 0.3
                                            if abs(value.translation.width) > swipeThreshold {
                                                if value.translation.width < 50 && quoteManager.currentQuoteIndex < maxQuoteIndex {
                                                    withAnimation {
                                                        offset = -UIScreen.main.bounds.width
                                                    }
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                                        nextQuote()
                                                        offset = 0
                                                    }
                                                } else if value.translation.width > -50 && quoteManager.currentQuoteIndex > 0 {
                                                    withAnimation {
                                                        offset = UIScreen.main.bounds.width
                                                    }
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                        previousQuote()
                                                        offset = 0
                                                    }
                                                } else {
                                                    withAnimation {
                                                        offset = 0
                                                    }
                                                }
                                            } else {
                                                withAnimation {
                                                    offset = 0
                                                }
                                            }
                                        }
                                    }
                            )
                            
                            // Add the author bio card here
                            // Add the author bio card here
                            if quoteManager.currentQuoteIndex == 0 && accessibleQuotes[safe: 0]?.id == quoteManager.quoteOfTheDay?.quote.id {
                                if let currentQuote = accessibleQuotes[safe: quoteManager.currentQuoteIndex] {
                                    AuthorBio(authorName: currentQuote.author)
                                        .padding(.bottom)
                                        .offset(x: offset, y: 0)  // Add offset just to the bio
                                        .rotationEffect(.degrees(Double(offset / 10)))  // Add rotation just to the bio
                                        .id(currentQuote.id) // Force view recreation when quote changes
                                }
                            }
                        }
                        
                        
                        //                    .shadow(color: Color.gray.opacity(0.1), radius: 10, x: 0, y: 5)
                    }
                }
                //                HStack {
                //                    Button(action: {
                //                        if quoteManager.currentQuoteIndex > 0 {
                //                            withAnimation { offset = UIScreen.main.bounds.width }
                //                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                //                                previousQuote()
                //                                offset = 0
                //                            }
                //                        }
                //                    }) {
                //                        Image(systemName: "chevron.left")
                //                            .foregroundColor(quoteManager.currentQuoteIndex > 0 ? .blue : .gray)
                //                    }
                //                    .disabled(quoteManager.currentQuoteIndex == 0)
                //                    .padding()
                //                    .background(quoteManager.currentQuoteIndex > 0 ? .yellow : .gray.opacity(0.1))
                //                    .clipShape(.circle)
                //
                //
                //                    Spacer()
                //
                //                    Button(action: {
                //                        if quoteManager.currentQuoteIndex < quoteManager.quotes.count - 1 {
                //                            withAnimation { offset = -UIScreen.main.bounds.width }
                //                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                //                                nextQuote()
                //                                offset = 0
                //                            }
                //                        }
                //                    }) {
                //                        Image(systemName: "chevron.right")
                //                            .foregroundColor(quoteManager.currentQuoteIndex < quoteManager.quotes.count - 1 ? .blue : .gray)
                //                    }
                //                    .disabled(quoteManager.currentQuoteIndex == quoteManager.quotes.count - 1)
                //                    .padding()
                //                    .background(.yellow)
                //                    .clipShape(.circle)
                //                }
                //                .padding()
            }
        }
//                    .onAppear {
//                        quoteManager.checkAndUpdateQuoteOfTheDay()
//                    }
            //FIXME: but when we click onappear i don't want the page to load up the quoteoftheday unless it's a new day
    }
        .accentColor(Color.black) // Sets a universal accent color for the navigation
        .sheet(isPresented: $showNotificationSettings) {
            NotificationSettingsView()
        }
}
        
    private func nextQuote() {
        let newIndex = quoteManager.currentQuoteIndex + 1
        if newIndex < accessibleQuotes.count {
            quoteManager.currentQuoteIndex = newIndex
        } else if !subscriptionManager.isPremiumUser && newIndex >= 500 {
            // Reset to beginning for free users (cycling behavior)
            quoteManager.currentQuoteIndex = 0
        }
    }
    
    private func previousQuote() {
        quoteManager.currentQuoteIndex = max(quoteManager.currentQuoteIndex - 1, 0)
    }
    
    }

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    Quotes(showSideBar: .constant(false),            showContext: { _ in }  // Add empty closure for preview
)
        .environmentObject(QuoteManager())
}
