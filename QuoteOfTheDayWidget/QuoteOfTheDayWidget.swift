//
//  QuoteOfTheDayWidget.swift
//  QuoteOfTheDayWidget
//
//  Created by Barbara on 03/01/2025.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    let userDefaultsManager = UserDefaultsManager.shared

    func placeholder(in context: Context) -> QuoteEntry {
        QuoteEntry(date: Date(), quote: Quote(topic: "Placeholder", quote: "Loading...", author: "..."))
    }

    func getSnapshot(in context: Context, completion: @escaping (QuoteEntry) -> ()) {
        let entry = QuoteEntry(date: Date(), quote: UserDefaultsManager.shared.loadQuoteOfTheDay()?.quote ?? Quote(topic: "Example", quote: "Loading...", author: "..."))
        completion(entry)
    }
    
        func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
            let currentDate = Date()
            let nextUpdateDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
            
            // Check if we need to update the quote
            if let savedQuote = userDefaultsManager.loadQuoteOfTheDay(),
               Calendar.current.isDateInToday(savedQuote.date) {
                // Use existing quote
                let entry = QuoteEntry(date: currentDate, quote: savedQuote.quote)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
                completion(timeline)
            } else {
                // Need to update quote - find quote by date
                Task {
                    do {
                        // Load quotes from bundle
                        if let url = Bundle.main.url(forResource: "quotes", withExtension: "json") {
                            let data = try Data(contentsOf: url)
                            let quotes = try JSONDecoder().decode([Quote].self, from: data)
                            
                            // Get today's date string
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            let todayString = dateFormatter.string(from: currentDate)
                            
                            // Find quote with matching date
                            if let quoteForToday = quotes.first(where: { quote in
                                guard let quoteDate = quote.date else { return false }
                                return quoteDate == todayString
                            }) {
                                // Save the new quote
                                userDefaultsManager.saveQuoteOfTheDay(quoteForToday, date: currentDate)
                                
                                let entry = QuoteEntry(date: currentDate, quote: quoteForToday)
                                let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
                                completion(timeline)
                            } else {
                                // Fallback to existing quote or default
                                if let savedQuote = userDefaultsManager.loadQuoteOfTheDay()?.quote {
                                    let entry = QuoteEntry(date: currentDate, quote: savedQuote)
                                    let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
                                    completion(timeline)
                                } else {
                                    let fallbackQuote = Quote(topic: "Daily Inspiration", quote: "Tap to open the app and see today's quote of the day", author: "Success Quotes")
                                    let entry = QuoteEntry(date: currentDate, quote: fallbackQuote)
                                    let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
                                    completion(timeline)
                                }
                            }
                        }
                    } catch {
                        // Fallback to existing quote or default
                        if let savedQuote = userDefaultsManager.loadQuoteOfTheDay()?.quote {
                            let entry = QuoteEntry(date: currentDate, quote: savedQuote)
                            let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
                            completion(timeline)
                        } else {
                            let fallbackQuote = Quote(topic: "Motivation", quote: "Open the app to see today's quote", author: "Success Quotes")
                            let entry = QuoteEntry(date: currentDate, quote: fallbackQuote)
                            let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
                            completion(timeline)
                        }
                    }
                }
            }
        }
    }

struct QuoteEntry: TimelineEntry {
    let date: Date
    let quote: Quote
}

struct QuoteOfTheDayWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var widgetFamily
    @State private var authorImage: UIImage? = nil

    var body: some View {
        ZStack {
            Color(.systemBackground) // This provides the default widget background
            
            VStack(alignment: .center, spacing: 8) {
                Text(entry.quote.quote)
                    .font(.custom("NewYork-Regular", size: 16))
//                    .lineSpacing(5)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                Text(entry.quote.author)
                    .font(.custom("NewYork-Regular", size: 14))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
               
            }
            .padding()
        }
        .widgetBackground(Color(.systemBackground)) // This is for iOS 15 widget background
        .widgetURL(URL(string: "successquotes://quoteOfTheDay"))
    }
}

struct QuoteOfTheDayWidget: Widget {
    let kind: String = "QuoteOfTheDayWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            QuoteOfTheDayWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Quote of the Day")
        .description("Start your day with inspiration")
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabled()
    }
}

struct QuoteOfTheDayWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            QuoteOfTheDayWidgetEntryView(entry: QuoteEntry(
                date: Date(),
                quote: Quote(
                    topic: "Preview",
                    quote: "The best way to predict the future is to create it.",
                    author: "Peter Drucker"
                )
            ))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            QuoteOfTheDayWidgetEntryView(entry: QuoteEntry(
                date: Date(),
                quote: Quote(
                    topic: "Preview",
                    quote: "Success is not final, failure is not fatal: it is the courage to continue that counts.",
                    author: "Winston Churchill"
                )
            ))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
}

// Add this extension for iOS 15 widget background compatibility
extension View {
    func widgetBackground(_ background: some View) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            return containerBackground(for: .widget) {
                background
            }
        } else {
            return background
        }
    }
}
