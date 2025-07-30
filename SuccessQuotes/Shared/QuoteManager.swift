//
//  QuoteManager.swift
//  SuccessQuotes
//
//  Created by Barbara on 16/10/2024.
//

import SwiftUI
import Foundation
import WidgetKit

class QuoteManager: ObservableObject {
    static let shared = QuoteManager()
    @Published var quotes: [Quote] = []
    @Published var savedQuotesOrder: [String] = []
    @Published var filteredQuotes: [Quote]?
    @Published var filterType: FilterType?
    @Published var recentlyDeletedQuote: Quote?
    @Published var showUndoButton: Bool = false
    @Published var currentQuoteIndex: Int = 0
    @Published var quoteOfTheDay: (quote: Quote, date: Date)?

    private let favoritesKey = "FavoriteQuotes"
    private let userDefaultsManager = UserDefaultsManager.shared


    init() {
        loadQuotes()
        loadFavorites()
        checkAndUpdateQuoteOfTheDay()
        shuffleRegularQuotes()
    }


    @objc private func handleSignificantTimeChange() {
        checkAndUpdateQuoteOfTheDay()
    }

    func checkAndUpdateQuoteOfTheDay() {
        print("🔄 Checking for quote of the day updates...")
        
        if let current = userDefaultsManager.loadQuoteOfTheDay() {
            let isToday = Calendar.current.isDateInToday(current.date)
            print("📅 Current quote date: \(current.date)")
            print("📅 Is today: \(isToday)")
            
            if !isToday {
                // Date has changed, generate new quote of the day
                print("🆕 Date has changed, generating new quote of the day...")
                generateNewQuoteOfTheDay()
            } else {
                print("✅ Quote of the day is current")
                quoteOfTheDay = current
                if let quoteId = userDefaultsManager.loadQuoteOfTheDayId(),
                   let quote = quotes.first(where: { $0.id == quoteId }) {
                    moveQuoteOfTheDayToFront()
                }
            }
            loadFavorites()
        } else {
            // No quote of the day exists, generate one
            print("🆕 No quote of the day exists, generating one...")
            generateNewQuoteOfTheDay()
            loadFavorites()
        }
    }
    
    private func generateNewQuoteOfTheDay() {
        // Get the exact current date
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayString = dateFormatter.string(from: today)
        
        print("🔍 Looking for quote with date: \(todayString)")
        
        // Find quote with matching date - MUST find one, no fallback
        guard let quoteForToday = quotes.first(where: { quote in
            guard let quoteDate = quote.date else { return false }
            let matches = quoteDate == todayString
            if matches {
                print("✅ Found matching quote: \(quote.quote) by \(quote.author)")
            }
            return matches
        }) else {
            print("❌ ERROR: No quote found for date \(todayString)")
            // If no quote found, we need to handle this case properly
            // For now, let's use the first quote as a last resort
            if let firstQuote = quotes.first {
                print("⚠️ Using first quote as fallback")
                userDefaultsManager.saveQuoteOfTheDay(firstQuote, date: today)
                quoteOfTheDay = (quote: firstQuote, date: today)
                moveQuoteOfTheDayToFront()
                WidgetCenter.shared.reloadAllTimelines()
            }
            return
        }
        
        // Save the quote for today
        userDefaultsManager.saveQuoteOfTheDay(quoteForToday, date: today)
        quoteOfTheDay = (quote: quoteForToday, date: today)
        moveQuoteOfTheDayToFront()
        
        // Update widget
        WidgetCenter.shared.reloadAllTimelines()
        
        // Notify UI that quote of the day has changed
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    // Add this method for debugging and force regeneration
    func forceRegenerateQuoteOfTheDay() {
        print("🔄 Force regenerating quote of the day...")
        generateNewQuoteOfTheDay()
    }
    
    // Add method to check if current quote matches today's date
    func isCurrentQuoteOfTheDayForToday() -> Bool {
        guard let currentQuote = quoteOfTheDay?.quote,
              let currentDate = quoteOfTheDay?.date else {
            return false
        }
        
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayString = dateFormatter.string(from: today)
        
        // Check if the quote has a date and it matches today
        if let quoteDate = currentQuote.date {
            return quoteDate == todayString
        }
        
        // If quote doesn't have a date, check if it was saved today
        let savedDateString = dateFormatter.string(from: currentDate)
        return savedDateString == todayString
    }
    
    // Add method to check if app needs to update quote of the day
    func needsQuoteOfTheDayUpdate() -> Bool {
        guard let current = userDefaultsManager.loadQuoteOfTheDay() else {
            return true // No quote exists, need to generate one
        }
        
        return !Calendar.current.isDateInToday(current.date)
    }

    func moveQuoteOfTheDayToFront() {
        if let quoteOfTheDay = quoteOfTheDay?.quote {
            if let existingQuote = quotes.first(where: { $0.id == quoteOfTheDay.id }) {
                // Preserve the favorite status
                var updatedQuote = quoteOfTheDay
                updatedQuote.isFavorite = existingQuote.isFavorite
                quotes.removeAll { $0.id == quoteOfTheDay.id }
                quotes.insert(updatedQuote, at: 0)
            } else {
                quotes.removeAll { $0.id == quoteOfTheDay.id }
                quotes.insert(quoteOfTheDay, at: 0)
            }
        }
    }
    
    func scrollToQuoteOfTheDay() {
        // Ensure quote of the day is at the front
        moveQuoteOfTheDayToFront()
        // Set current index to 0 to show the quote of the day
        currentQuoteIndex = 0
        // Clear any filters to show the main quotes list
        clearFilter()
    }

    func undoDelete() {
        if let deletedQuote = recentlyDeletedQuote {
            if let index = quotes.firstIndex(where: { $0.id == deletedQuote.id }) {
                quotes[index].isFavorite = true
                savedQuotesOrder.insert(deletedQuote.id, at: 0)
                saveFavorites()
            }
            recentlyDeletedQuote = nil
            showUndoButton = false
        }
    }

    func normalizeApostrophes(_ text: String) -> String {
        text.lowercased()
            .replacingOccurrences(of: "'", with: "’")
            .replacingOccurrences(of: "’", with: "'")
    }

    func searchQuotes(query: String) -> [Quote] {
        let lowercasedQuery = normalizeApostrophes(query.trimmingCharacters(in: .whitespacesAndNewlines))
        if lowercasedQuery.isEmpty { return [] }

        let searchWords = lowercasedQuery.split(separator: " ")

        return quotes.filter { quote in
            let normalizedQuote = normalizeApostrophes(quote.quote)
            let normalizedAuthor = normalizeApostrophes(quote.author)
            let normalizedTopic = normalizeApostrophes(quote.topic)

            let quoteWords = normalizedQuote.split(separator: " ")
            let authorWords = normalizedAuthor.split(separator: " ")
            let topicWords = normalizedTopic.split(separator: " ")

            return searchWords.allSatisfy { searchWord in
                quoteWords.contains { $0.hasPrefix(searchWord) } ||
                authorWords.contains { $0.hasPrefix(searchWord) } ||
                topicWords.contains { $0.hasPrefix(searchWord) }
            }
        }
    }

    enum FilterType {
        case author(String)
        case topic(String)
    }

    func filterByAuthor(_ author: String) {
        filteredQuotes = quotes.filter { $0.author == author }
        filterType = .author(author)
    }

    func filterByTopic(_ topic: String) {
        filteredQuotes = quotes.filter { $0.topic == topic }
        filterType = .topic(topic)
    }

    func clearFilter() {
        filteredQuotes = nil
        filterType = nil
    }

    var topics: [String] {
        Array(Set(quotes.map { $0.topic })).sorted()
    }

    func loadQuotes() {
        if let url = Bundle.main.url(forResource: "quotes", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                self.quotes = try decoder.decode([Quote].self, from: data)
                
                // Debug: Check if dates are being loaded properly
                print("📚 Loaded \(quotes.count) quotes")
                let quotesWithDates = quotes.filter { $0.date != nil }
                print("📅 Quotes with dates: \(quotesWithDates.count)")
                
                // Show first few quotes with dates
                for (index, quote) in quotes.prefix(5).enumerated() {
                    print("Quote \(index + 1): date=\(quote.date ?? "nil"), author=\(quote.author)")
                }
                
            } catch {
                print("Error loading JSON data: \(error)")
            }
        }
    }

    private func loadSavedQuotesOrder() {
        if let order = userDefaultsManager.userDefaults.stringArray(forKey: "SavedQuotesOrder") {
            savedQuotesOrder = order
        }
    }

    func loadFavorites() {
        if let order = userDefaultsManager.userDefaults.stringArray(forKey: "SavedQuotesOrder") {
            savedQuotesOrder = order
        }

        if let favoriteQuoteIds = userDefaultsManager.userDefaults.stringArray(forKey: favoritesKey) {
            for (index, quote) in quotes.enumerated() {
                quotes[index].isFavorite = favoriteQuoteIds.contains(quote.id)
                if quotes[index].isFavorite && !savedQuotesOrder.contains(quote.id) {
                    savedQuotesOrder.insert(quote.id, at: 0)
                }
            }
        }
    }

    func toggleFavorite(for quoteId: String) {
        if let index = quotes.firstIndex(where: { $0.id == quoteId }) {
            quotes[index].isFavorite.toggle()

            if quotes[index].isFavorite {
                savedQuotesOrder.insert(quoteId, at: 0)
            } else {
                savedQuotesOrder.removeAll { $0 == quoteId }
            }

            saveFavorites()
        }
    }

    func saveFavorites() {
        let favoriteQuoteIds = quotes.filter { $0.isFavorite }.map { $0.id }
        userDefaultsManager.userDefaults.set(favoriteQuoteIds, forKey: favoritesKey)
        userDefaultsManager.userDefaults.set(savedQuotesOrder, forKey: "SavedQuotesOrder")
        userDefaultsManager.userDefaults.synchronize()
    }

    func quotes(for topic: String) -> [Quote] {
        quotes.filter { $0.topic == topic }
    }

    func shuffleRegularQuotes() {
        if quotes.count > 1 {
            let firstQuote = quotes[0]
            var restOfQuotes = Array(quotes.dropFirst())
            restOfQuotes.shuffle()
            quotes = [firstQuote] + restOfQuotes
        }
        loadFavorites()
    }

    // MARK: - Debug Methods
    func debugQuoteOfTheDay(for dateString: String) {
        print("🔍 Debug: Looking for quote with date: \(dateString)")
        
        let matchingQuotes = quotes.filter { quote in
            guard let quoteDate = quote.date else { return false }
            return quoteDate == dateString
        }
        
        print("📊 Found \(matchingQuotes.count) quotes for date \(dateString)")
        
        for (index, quote) in matchingQuotes.enumerated() {
            print("Quote \(index + 1): \(quote.quote) by \(quote.author)")
        }
    }
    
    func debugCurrentDate() {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayString = dateFormatter.string(from: today)
        
        print("📅 Current date: \(todayString)")
        print("📚 Total quotes loaded: \(quotes.count)")
        
        let quotesWithDates = quotes.filter { $0.date != nil }
        print("📅 Quotes with dates: \(quotesWithDates.count)")
        
        // Check if we have a quote for today
        let todayQuotes = quotes.filter { quote in
            guard let quoteDate = quote.date else { return false }
            return quoteDate == todayString
        }
        
        print("🎯 Quotes for today (\(todayString)): \(todayQuotes.count)")
        
        if let currentQuote = quoteOfTheDay?.quote {
            print("✅ Current quote of the day: \(currentQuote.quote) by \(currentQuote.author)")
            print("📅 Quote date: \(currentQuote.date ?? "nil")")
        } else {
            print("❌ No quote of the day set")
        }
    }
    
}

//check duplicates
//extension QuoteManager {
//    func printDuplicates() {
//        var seenQuotes = Set<String>()
//        var duplicates = [Quote]()
//
//        for quote in quotes {
//            let quoteIdentifier = "\(quote.topic)-\(quote.quote)-\(quote.author)"
//            if seenQuotes.contains(quoteIdentifier) {
//                duplicates.append(quote)
//            } else {
//                seenQuotes.insert(quoteIdentifier)
//            }
//        }
//
//        if duplicates.isEmpty {
//            print("No duplicates found.")
//        } else {
//            print("Duplicates:")
//            for duplicate in duplicates {
//                print("Topic: \(duplicate.topic), Quote: \(duplicate.quote), Author: \(duplicate.author)")
//            }
//        }
//    }
//}
