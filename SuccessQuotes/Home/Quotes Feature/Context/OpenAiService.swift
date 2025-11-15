//
//  OpenAiService.swift
//  SuccessQuotes
//
//  Created by Barbara on 28/11/2024.
//

import Foundation

// Data model for structured quote context
struct QuoteContext {
    let quote: String
    let authorName: String  // Will be populated from quote.author, not from OpenAI
    let birthYear: String?
    let deathYear: String?
    let historicalContext: String
    let quoteBreakdown: String
    let keyWorks: [String]
}

// Internal struct for decoding OpenAI API response (handles flexible year types)
private struct QuoteContextAPIResponse: Codable {
    let quote: String
    let birthYear: String?
    let deathYear: String?
    let historicalContext: String
    let quoteBreakdown: String
    let keyWorks: [String]
    
    enum CodingKeys: String, CodingKey {
        case quote, birthYear, deathYear, historicalContext, quoteBreakdown, keyWorks
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        quote = try container.decode(String.self, forKey: .quote)
        historicalContext = try container.decode(String.self, forKey: .historicalContext)
        quoteBreakdown = try container.decode(String.self, forKey: .quoteBreakdown)
        keyWorks = try container.decode([String].self, forKey: .keyWorks)
        
        // Handle birthYear - can be String, Int, or null
        if let yearString = try? container.decode(String.self, forKey: .birthYear) {
            birthYear = yearString
        } else if let yearInt = try? container.decode(Int.self, forKey: .birthYear) {
            birthYear = String(yearInt)
        } else {
            birthYear = nil
        }
        
        // Handle deathYear - can be String, Int, or null
        if let yearString = try? container.decode(String.self, forKey: .deathYear) {
            deathYear = yearString
        } else if let yearInt = try? container.decode(Int.self, forKey: .deathYear) {
            deathYear = String(yearInt)
        } else {
            deathYear = nil
        }
    }
}

class OpenAIService {
    private let apiKey: String = Bundle.main.object(forInfoDictionaryKey: "OpenAI_API_Key") as? String ?? ""
    private let endpoint = "https://api.openai.com/v1/chat/completions"
    private let timeoutInterval: TimeInterval = 30.0 // 30 second timeout
    
    func getQuoteContext(quote: Quote) async throws -> QuoteContext {
        // Properly escape quote text to prevent JSON/prompt issues
        let escapedQuote = quote.quote
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "\r", with: " ")
        
        let escapedAuthor = quote.author
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
        
        let prompt = """
        Please provide structured information about this quote: "\(escapedQuote)" by \(escapedAuthor).
        
        Return a JSON response with the following structure:
        {
            "quote": "the exact quote text",
            "birthYear": "year born as a STRING (e.g., '1879', '4 BC'), or null if unknown",
            "deathYear": "year died as a STRING (e.g., '1955', '65 AD'), or null if unknown",
            "historicalContext": "2-3 sentences about when, where, and why this quote was said",
            "quoteBreakdown": "2-3 sentences explaining what the author meant and the deeper meaning",
            "keyWorks": ["1-3 major works or achievements the author is known for"]
        }
        
        IMPORTANT: birthYear and deathYear must be strings in quotes, not numbers. Use null (not "null") if unknown. Keep all text concise and informative.
        """
        
        let messages: [[String: Any]] = [
            ["role": "system", "content": "You are a knowledgeable historian and literary expert. Always respond with valid JSON in the exact format requested."],
            ["role": "user", "content": prompt]
        ]
        
        let requestBody: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": messages,
            "max_tokens": 400,
            "response_format": ["type": "json_object"]
        ]
        
        // Validate API key first
        guard !apiKey.isEmpty else {
            throw NSError(domain: "OpenAIError", code: 0, userInfo: [NSLocalizedDescriptionKey: "API key not configured"])
        }
        
        // Serialize request body - throw error if it fails
        let requestData: Data
        do {
            requestData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            print("❌ Failed to serialize request body: \(error)")
            throw NSError(domain: "OpenAIError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create request: \(error.localizedDescription)"])
        }
        
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.timeoutInterval = timeoutInterval
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestData
        
        do {
            let (data, httpResponse) = try await URLSession.shared.data(for: request)
            
            // Check HTTP status code
            if let httpResponse = httpResponse as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                
                // Handle error status codes
                switch httpResponse.statusCode {
                case 401:
                    throw NSError(domain: "OpenAIError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid API key"])
                case 429:
                    throw NSError(domain: "OpenAIError", code: 429, userInfo: [NSLocalizedDescriptionKey: "Rate limit exceeded. Please try again later"])
                case 500...599:
                    throw NSError(domain: "OpenAIError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "OpenAI service error. Please try again"])
                case 200...299:
                    break // Success
                default:
                    throw NSError(domain: "OpenAIError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Request failed with status \(httpResponse.statusCode)"])
                }
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response JSON: \(jsonString)")
            }
            
            let decodedResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)
            guard let jsonString = decodedResponse.choices.first?.message.content else {
                throw NSError(domain: "OpenAIError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No content received from OpenAI"])
            }
            
            // Parse the JSON content into QuoteContext
            guard let jsonData = jsonString.data(using: .utf8) else {
                throw NSError(domain: "OpenAIError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to convert response to data"])
            }
            
            // Decode to temporary response struct
            let apiResponse = try JSONDecoder().decode(QuoteContextAPIResponse.self, from: jsonData)
            
            // Create QuoteContext with the author from the Quote object
            return QuoteContext(
                quote: apiResponse.quote,
                authorName: quote.author,  // Use the original author name from quote
                birthYear: apiResponse.birthYear,
                deathYear: apiResponse.deathYear,
                historicalContext: apiResponse.historicalContext,
                quoteBreakdown: apiResponse.quoteBreakdown,
                keyWorks: apiResponse.keyWorks
            )
        } catch {
            print("Error: \(error)")
            throw error
        }
    }
}

struct OpenAIResponse: Codable {
    let choices: [Choice]
    
    struct Choice: Codable {
        let message: Message
    }
    
    struct Message: Codable {
        let content: String
    }
}
