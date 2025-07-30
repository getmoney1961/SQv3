////
////  OpenAiService.swift
////  SuccessQuotes
////
////  Created by Barbara on 28/11/2024.
////
//
//import Foundation
//
//class OpenAIService {
//    private let apiKey: String = Bundle.main.object(forInfoDictionaryKey: "OpenAI_API_Key") as? String ?? ""
//    private let endpoint = "https://api.openai.com/v1/chat/completions"
//    
//    func getQuoteContext(quote: Quote) async throws -> String {
//        let prompt = """
//        Please provide historical context about this quote: "\(quote.quote)" by \(quote.author). What did the author mean when they said it, when and why they said it (if known).
//        Include where the quote is from.       
//        Keep the response concise, around 2-3 sentences.
//        """
//        
//        let messages: [[String: Any]] = [
//            ["role": "system", "content": "You are a yoda type, oracle and success guru providing deep meanings and historical context for success quotes."],
//            ["role": "user", "content": prompt]
//        ]
//        
//        let requestBody: [String: Any] = [
//            "model": "gpt-3.5-turbo",
//            "messages": messages,
//            "max_tokens": 150
//        ]
//        
//        var request = URLRequest(url: URL(string: endpoint)!)
//        request.httpMethod = "POST"
//        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
//        
//        do {
//            let (data, httpResponse) = try await URLSession.shared.data(for: request)
//            
//            // Print response for debugging
//            if let httpResponse = httpResponse as? HTTPURLResponse {
//                print("HTTP Status Code: \(httpResponse.statusCode)")
//            }
//            
//            if let jsonString = String(data: data, encoding: .utf8) {
//                print("Response JSON: \(jsonString)")
//            }
//            
//            let decodedResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)
//            return decodedResponse.choices.first?.message.content ?? "Context not available."
//        } catch {
//            print("Error: \(error)")
//            throw error
//        }
//    }
//}
//
//struct OpenAIResponse: Codable {
//    let choices: [Choice]
//    
//    struct Choice: Codable {
//        let message: Message
//    }
//    
//    struct Message: Codable {
//        let content: String
//    }
//}
