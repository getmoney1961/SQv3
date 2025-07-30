import Foundation
import SwiftUI
import UIKit
import SafariServices

struct WikiResponse {
    let bio: String
    let url: URL?
}

func fetchWikipediaSummaryAndURL(for author: String, completion: @escaping (Result<WikiResponse, Error>) -> Void) {
    let attempts = [
        author,
        cleanupAuthorName(author),
        author.components(separatedBy: " ").first ?? author
    ]
    
    tryNextAttempt(attempts: attempts, currentIndex: 0) { result in
        switch result {
        case .success(let bio):
            let urlString = "https://en.wikipedia.org/wiki/\(author.replacingOccurrences(of: " ", with: "_"))"
            let response = WikiResponse(
                bio: bio,
                url: URL(string: urlString)
            )
            completion(.success(response))
        case .failure(let error):
            completion(.failure(error))
        }
    }
}

private func tryNextAttempt(attempts: [String], currentIndex: Int, completion: @escaping (Result<String, Error>) -> Void) {
    guard currentIndex < attempts.count else {
        completion(.failure(NSError(domain: "", code: -1, userInfo: [
            NSLocalizedDescriptionKey: "Could not find biography for this author"
        ])))
        return
    }
    
    let currentAttempt = attempts[currentIndex]
    let encodedAuthor = currentAttempt.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? currentAttempt
    let urlString = "https://en.wikipedia.org/api/rest_v1/page/summary/\(encodedAuthor)"
    
    guard let url = URL(string: urlString) else {
        tryNextAttempt(attempts: attempts, currentIndex: currentIndex + 1, completion: completion)
        return
    }
    
    print("🔍 Trying to fetch bio for: \(currentAttempt)")
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode == 404 {
            tryNextAttempt(attempts: attempts, currentIndex: currentIndex + 1, completion: completion)
            return
        }
        
        guard let data = data else {
            tryNextAttempt(attempts: attempts, currentIndex: currentIndex + 1, completion: completion)
            return
        }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let extract = json["extract"] as? String {
                if extract.split(separator: " ").count > 5 {
                    let limitedExtract = limitBioLength(extract, maxWords: 15)
                    completion(.success(limitedExtract))
                } else {
                    tryNextAttempt(attempts: attempts, currentIndex: currentIndex + 1, completion: completion)
                }
            } else {
                tryNextAttempt(attempts: attempts, currentIndex: currentIndex + 1, completion: completion)
            }
        } catch {
            tryNextAttempt(attempts: attempts, currentIndex: currentIndex + 1, completion: completion)
        }
    }.resume()
}

func fetchWikipediaImage(for author: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
    let attempts = [
        author,
        cleanupAuthorName(author),
        author.components(separatedBy: " ").first ?? author
    ]
    
    tryNextImageAttempt(attempts: attempts, currentIndex: 0, completion: completion)
}

private func tryNextImageAttempt(attempts: [String], currentIndex: Int, completion: @escaping (Result<UIImage, Error>) -> Void) {
    guard currentIndex < attempts.count else {
        completion(.failure(NSError(domain: "", code: -1, userInfo: [
            NSLocalizedDescriptionKey: "Could not find image for this author"
        ])))
        return
    }
    
    let currentAttempt = attempts[currentIndex]
    let encodedAuthor = currentAttempt.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? currentAttempt
    let urlString = "https://en.wikipedia.org/api/rest_v1/page/summary/\(encodedAuthor)"
    
    guard let url = URL(string: urlString) else {
        tryNextImageAttempt(attempts: attempts, currentIndex: currentIndex + 1, completion: completion)
        return
    }
    
    print("🔍 Trying to fetch image for: \(currentAttempt)")
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            tryNextImageAttempt(attempts: attempts, currentIndex: currentIndex + 1, completion: completion)
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode == 404 {
            tryNextImageAttempt(attempts: attempts, currentIndex: currentIndex + 1, completion: completion)
            return
        }
        
        guard let data = data else {
            tryNextImageAttempt(attempts: attempts, currentIndex: currentIndex + 1, completion: completion)
            return
        }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let originalImage = json["originalimage"] as? [String: Any],
               let imageUrlString = originalImage["source"] as? String,
               let imageUrl = URL(string: imageUrlString) {
                
                URLSession.shared.dataTask(with: imageUrl) { imageData, imageResponse, imageError in
                    if let imageError = imageError {
                        tryNextImageAttempt(attempts: attempts, currentIndex: currentIndex + 1, completion: completion)
                        return
                    }
                    
                    guard let imageData = imageData,
                          let image = UIImage(data: imageData) else {
                        tryNextImageAttempt(attempts: attempts, currentIndex: currentIndex + 1, completion: completion)
                        return
                    }
                    
                    completion(.success(image))
                }.resume()
                
            } else {
                tryNextImageAttempt(attempts: attempts, currentIndex: currentIndex + 1, completion: completion)
            }
        } catch {
            tryNextImageAttempt(attempts: attempts, currentIndex: currentIndex + 1, completion: completion)
        }
    }.resume()
}

func cleanupAuthorName(_ name: String) -> String {
    let nameCorrections = [
        "Dr. Martin Luther King Jr.": "Martin Luther King Jr.",
        "Dr. Seuss": "Dr. Seuss",
        "Saint Augustine": "Augustine of Hippo",
        "Lao Tzu": "Laozi",
        "Confucius": "Confucius",
        "Stephen Hawking": "Stephen Hawking",
        "Albert Einstein": "Albert Einstein",
        "Socrates": "Socrates",
        "Marcus Aurelius": "Marcus Aurelius",
        "Leonardo da Vinci": "Leonardo da Vinci",
        "Mother Teresa": "Mother Teresa",
        "Mahatma Gandhi": "Mahatma Gandhi",
        "Winston Churchill": "Winston Churchill",
        "Steve Jobs": "Steve Jobs",
        "Seneca": "Seneca the Younger",
    ]
    
    if let correctedName = nameCorrections[name] {
        return correctedName
    }
    
    var cleanName = name
        .replacingOccurrences(of: "Dr. ", with: "")
        .replacingOccurrences(of: "Prof. ", with: "")
        .replacingOccurrences(of: "Sir ", with: "")
        .trimmingCharacters(in: .whitespacesAndNewlines)
    
    if !name.contains("Luther King") {
        cleanName = cleanName
            .replacingOccurrences(of: " Jr.", with: "")
            .replacingOccurrences(of: " Sr.", with: "")
            .replacingOccurrences(of: " III", with: "")
    }
    
    return cleanName
}

private func limitBioLength(_ bio: String, maxWords: Int) -> String {
    let words = bio.split(separator: " ")
    if words.count <= maxWords {
        return bio
    }
    
    let truncatedBio = words.prefix(maxWords).joined(separator: " ")
    return truncatedBio + "..."
}
