//
//  QuoteModel.swift
//  SuccessQuotes
//
//  Created by Barbara on 16/10/2024.
//

import SwiftUI
import Foundation

struct Quote: Codable, Identifiable {
    let id: String // Now using the UUID from JSON
    var topic: String
    var quote: String
    var author: String
    var category: String = "Unknown"
    var isFavorite: Bool = false
    var date: String? // Optional date field from JSON
    
    private enum CodingKeys: String, CodingKey {
        case id, topic, quote, author, category, date
    }
    
    init(topic: String, quote: String, author: String, category: String = "Unknown", isFavorite: Bool = false, date: String? = nil) {
        self.id = UUID().uuidString // For any new quotes created in code
        self.topic = topic
        self.quote = quote
        self.author = author
        self.category = category
        self.isFavorite = isFavorite
        self.date = date
    }
}
