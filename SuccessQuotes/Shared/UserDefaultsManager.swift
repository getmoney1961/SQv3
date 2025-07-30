//
//  UserDefaultsManager.swift
//  SuccessQuotes
//
//  Created by Barbara on 05/12/2024.
//

import Foundation
import SwiftUI

class UserDefaultsManager: ObservableObject {
    // MARK: - Singleton
    static let shared = UserDefaultsManager()
    
    // MARK: - Properties
    let userDefaults: UserDefaults
    
    // MARK: - Constants
    struct Keys {
        static let suite = "group.com.barbara.SuccessQuotesV2"

        struct Quote {
            static let quoteOfTheDay = "QuoteOfTheDay"
            static let quoteOfTheDayId = "QuoteOfTheDayId"
            static let lastUpdate = "LastUpdate"
            static let nextQuote = "NextQuote"
            static let nextDate = "NextDate"
            static let favorites = "FavoriteQuotes"
            static let savedOrder = "SavedQuotesOrder"
            static let notificationsEnabled = "NotificationsEnabled" // Add this line
            static let notificationTime = "NotificationTime" // Add this line
        }
    }
    
    // MARK: - Initialization
    private init() {
        if let groupUserDefaults = UserDefaults(suiteName: "group.com.barbara.SuccessQuotesV2") {
            self.userDefaults = groupUserDefaults
        } else {
            self.userDefaults = UserDefaults.standard
        }
    }
    
    // Add to UserDefaultsManager.swift clearAll() method:
    func clearAll() {
        let keys = [
            Keys.Quote.quoteOfTheDay,
            Keys.Quote.lastUpdate,
            Keys.Quote.nextQuote,
            Keys.Quote.nextDate,
            Keys.Quote.favorites,
            Keys.Quote.savedOrder,
            Keys.Quote.notificationsEnabled,  // Add this
            Keys.Quote.notificationTime       // Add this
        ]
        
        keys.forEach { userDefaults.removeObject(forKey: $0) }
        synchronize()
    }
    
    
    // MARK: - Quote of the Day Methods
    func saveQuoteOfTheDay(_ quote: Quote, date: Date) {
        do {
            let encoded = try JSONEncoder().encode(quote)
            userDefaults.set(encoded, forKey: Keys.Quote.quoteOfTheDay)
            userDefaults.set(quote.id, forKey: Keys.Quote.quoteOfTheDayId)
            userDefaults.set(date, forKey: Keys.Quote.lastUpdate)
            synchronize()
        } catch {
            print("❌ Error saving quote of the day: \(error.localizedDescription)")
        }
    }
    
    func loadQuoteOfTheDay() -> (quote: Quote, date: Date)? {
        do {
            guard let savedData = userDefaults.data(forKey: Keys.Quote.quoteOfTheDay),
                  let lastUpdate = userDefaults.object(forKey: Keys.Quote.lastUpdate) as? Date else {
                return nil
            }
            
            let quote = try JSONDecoder().decode(Quote.self, from: savedData)
            return (quote: quote, date: lastUpdate)
        } catch {
            print("❌ Error loading quote of the day: \(error.localizedDescription)")
            return nil
        }
    }
    
    func loadQuoteOfTheDayId() -> String? {
        return userDefaults.string(forKey: Keys.Quote.quoteOfTheDayId)
    }
    
    func clearQuoteOfTheDay() {
        userDefaults.removeObject(forKey: Keys.Quote.quoteOfTheDay)
        userDefaults.removeObject(forKey: Keys.Quote.quoteOfTheDayId)
        userDefaults.removeObject(forKey: Keys.Quote.lastUpdate)
        synchronize()
    }
    
    // MARK: - Next Quote Methods
    func saveNextQuote(_ quote: Quote, date: Date) {
        do {
            let encoded = try JSONEncoder().encode(quote)
            userDefaults.set(encoded, forKey: Keys.Quote.nextQuote)
            userDefaults.set(date, forKey: Keys.Quote.nextDate)
            synchronize()
        } catch {
            print("❌ Error saving next quote: \(error.localizedDescription)")
        }
    }
    
    func loadNextQuote() -> (quote: Quote, date: Date)? {
        do {
            guard let savedData = userDefaults.data(forKey: Keys.Quote.nextQuote),
                  let nextDate = userDefaults.object(forKey: Keys.Quote.nextDate) as? Date else {
                return nil
            }
            
            let quote = try JSONDecoder().decode(Quote.self, from: savedData)
            return (quote: quote, date: nextDate)
        } catch {
            print("❌ Error loading next quote: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: - Favorites Methods
    func saveFavorites(_ quoteIds: [String]) {
        userDefaults.set(quoteIds, forKey: Keys.Quote.favorites)
        synchronize()
    }
    
    func loadFavorites() -> [String] {
        userDefaults.stringArray(forKey: Keys.Quote.favorites) ?? []
    }
    
    // MARK: - Saved Order Methods
    func saveSavedOrder(_ order: [String]) {
        userDefaults.set(order, forKey: Keys.Quote.savedOrder)
        synchronize()
    }
    
    func loadSavedOrder() -> [String] {
        userDefaults.stringArray(forKey: Keys.Quote.savedOrder) ?? []
    }

    
    // MARK: - Notification Methods
    func saveNotificationSettings(enabled: Bool, time: Date = Date()) {
        userDefaults.set(enabled, forKey: Keys.Quote.notificationsEnabled)
        userDefaults.set(time, forKey: Keys.Quote.notificationTime)
        synchronize()
    }
    
    func loadNotificationSettings() -> (enabled: Bool, time: Date) {
        let enabled = userDefaults.bool(forKey: Keys.Quote.notificationsEnabled)
        let time = userDefaults.object(forKey: Keys.Quote.notificationTime) as? Date ?? Calendar.current.date(from: DateComponents(hour: 9, minute: 0)) ?? Date()
        return (enabled, time)
    }
    
    func isNotificationsEnabled() -> Bool {
        return userDefaults.bool(forKey: Keys.Quote.notificationsEnabled)
    }
    
    func getNotificationTime() -> Date {
        return userDefaults.object(forKey: Keys.Quote.notificationTime) as? Date ?? Calendar.current.date(from: DateComponents(hour: 9, minute: 0)) ?? Date()
    }

    // MARK: - Utility Methods
    
    private func synchronize() {
        userDefaults.synchronize()
    }
    
}
