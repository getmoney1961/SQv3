//
//  BookmarksView.swift
//  SuccessQuotes
//
//  Created by Barbara on 17/10/2024.
//

import SwiftUI

import SwiftUI

struct SavedQuotesView: View {
    @EnvironmentObject private var quoteManager: QuoteManager
    @Binding var selectedTab: Int  // Add this line
    
    var orderedDisplayedQuotes: [Quote] {
        let favoriteQuotes = quoteManager.quotes.filter { $0.isFavorite }
        return quoteManager.savedQuotesOrder.compactMap { quoteId in
            favoriteQuotes.first { $0.id == quoteId }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.981, green: 0.976, blue: 0.976).ignoresSafeArea(.all)
                VStack {
                HStack {
                    Text("Saved")
                        .font(.custom("EditorialNew-Regular", size: 32))
                        .foregroundColor(.black)
                        .lineLimit(1)
                    Spacer()
                }
                .padding(EdgeInsets(top: 16, leading: 16, bottom: 4, trailing: 16))
                    Spacer()
                if orderedDisplayedQuotes.isEmpty {  // Changed this condition
                    VStack {
                        Image("no-email")
                        Text("Like a quote to find it here")
                            .font(.headline)
                            .padding()
                        Button(action: {
                            selectedTab = 1  // Switch to Quotes tab
                        }) {
                            Text("Save a Quote")
                                .foregroundStyle(.white)
                                .padding(EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24))
                                .background(.black)
                                .cornerRadius(30)
                        }
                    }
                    .offset(y: -50)
                    Spacer()

                } else {
                    ScrollView(showsIndicators: false) {
                        VStack {
                            ForEach(orderedDisplayedQuotes, id: \.id) { quote in
                                SavedQuoteCard(quote: quote, onDelete: {
                                    quoteManager.toggleFavorite(for: quote.id)
                                })
                            }
                        }
                        .padding(.bottom, 8)
                    }
                }
            }
        }
//                .navigationBarTitleDisplayMode(.inline)
//                .toolbar {
//                    ToolbarItem(placement: .principal) {
//                        VStack {
//                            Text("Saved")
//                                .font(.custom("EditorialNew-Regular", size: 32))
//                              .foregroundColor(Color.black)
//                        }
//                    }
//                }
//            .background(Color(red: 0.981, green: 0.976, blue: 0.976).ignoresSafeArea(.all)) // Add this to ensure the entire card is tappable
        }
        .accentColor(Color.black) // Sets a universal accent color for the navigation
    }
}

struct SavedQuoteCard: View {
    let quote: Quote
    @EnvironmentObject private var quoteManager: QuoteManager
    let onDelete: () -> Void
    @State private var offset: CGFloat = 0
    @State private var isSwiped: Bool = false
    @State private var isDeleting: Bool = false
    @State private var isLocalFavorite: Bool
    @State private var isCustomShareSheetPresented = false

    init(quote: Quote, onDelete: @escaping () -> Void) {
        self.quote = quote
        self.onDelete = onDelete
        self._isLocalFavorite = State(initialValue: quote.isFavorite)
    }
    
    var body: some View {
        if isDeleting {
            // Undo button card
            Button(action: {
                isDeleting = false
                isLocalFavorite.toggle()
                isSwiped = false  // Reset swipe state
                offset = 0        // Reset offset
                quoteManager.undoDelete()
            }) {
                HStack {
                    Image(systemName: "arrow.uturn.backward")
                    Text("Undo")
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 24)
                .frame(maxWidth: .infinity)
                .background(Color.black.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 24))
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
            .transition(.opacity.combined(with: .scale))
            .onAppear {
                // After showing undo button for 3 seconds, remove the quote if not undone
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    if isDeleting {  // Only if still deleting
                        withAnimation {
                            onDelete()  // Actually remove the quote
                            isDeleting = false
                        }
                    }
                }
            }
        } else {
            NavigationLink(destination: FullScreenQuoteView(quote: quote)) {
                ZStack(alignment: .trailing) {
                    // Delete button
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation {  // Add animation here
                                isDeleting = true
                            }
                        }) {
                            Image(systemName: "trash")
                                .font(.title2)
                                .foregroundColor(.red)
                                .frame(width: 60, height: 50)
                        }
                    }
                    .opacity(offset < 0 ? 1 : 0) // Hide delete button when not swiped
                    
                    VStack(alignment: .center, spacing: 10) {
                        Text(quote.quote)
                            .font(.custom("NewYork-Regular", size: 16))
                            .lineSpacing(5)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding()

                        
                            Text(quote.author)
                            .font(.custom("NewYork-Regular", size: 12))
                                .foregroundColor(.gray)
                                .lineLimit(1)
                        Spacer()
                        HStack {

                            Text(quote.topic)
                                .font(.custom("Helvetica", size: 12))
                                .foregroundStyle(.black)

                            Spacer()
                            
                                Button(action: {
                                    isCustomShareSheetPresented = true
                                }) {
                                    Image("share")
                                        .resizable()
                                        .frame(width: 14, height: 16)
                                        .foregroundColor(.gray)
                                }
                                .sheet(isPresented: $isCustomShareSheetPresented) {
                                    NewShareSheet(quote: quote)
                                }

                                Button(action: {
                                    withAnimation {
                                        isLocalFavorite.toggle()
                                        isDeleting = true
                                    }
                                }) {
                                    Image(systemName: isLocalFavorite ? "suit.heart.fill" : "suit.heart")
                                        .foregroundColor(isLocalFavorite ? .red : .gray)
                                        .font(.system(size: 16, weight: .medium))
                                }
                            }
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    //        .shadow(color: Color.gray.opacity(0.1), radius: 10, x: 0, y: 5)
                    
                    .offset(x: offset)
//                    .simultaneousGesture (
//                        DragGesture()
//                            .onChanged { value in
//                                withAnimation {
//                                    offset = min(0, max(-60, value.translation.width))
//                                }
//                            }
//                            .onEnded { value in
//                                withAnimation {
//                                    if value.translation.width < -50 {
//                                        offset = -60
//                                        isSwiped = true
//                                    } else {
//                                        offset = 0
//                                        isSwiped = false
//                                    }
//                                }
//                            }
//                    )
                }
            }
            .transition(.opacity.combined(with: .scale))
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal)
            .opacity(1)  // Add this line to force full opacity
//            .background(Color(red: 0.981, green: 0.976, blue: 0.976))  // Add this line - match your background color
//            .padding(.bottom, 8)
        }
    }
}



struct SavedQuotesView_Previews: PreviewProvider {
    static var previews: some View {
        SavedQuotesView(selectedTab: .constant(1))  // Provide a constant binding with initial value 1
            .environmentObject(QuoteManager())
    }
}
