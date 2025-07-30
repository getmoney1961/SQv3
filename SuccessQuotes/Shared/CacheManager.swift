//
//  CachedImage.swift
//  SuccessQuotes
//
//  Created by Barbara on 27/12/2024.
//

import UIKit

class CacheManager {
    static let shared = CacheManager()
    private let imageCache: NSCache<NSString, UIImage>
    private let bioCache = NSCache<NSString, NSString>()
    private let urlCache = NSCache<NSString, NSURL>()
    private let userDefaults: UserDefaults
    private init() {
        imageCache = NSCache<NSString, UIImage>()
        imageCache.countLimit = 100
        
        // Use app group for shared storage
        if let groupUserDefaults = UserDefaults(suiteName: "group.com.barbara.SuccessQuotesV2") {
            userDefaults = groupUserDefaults
        } else {
            userDefaults = .standard
        }
    }
    
    // Image caching
    func getImage(for key: String) -> UIImage? {
        return imageCache.object(forKey: key as NSString)
    }
    
    func setImage(_ image: UIImage, for key: String) {
        imageCache.setObject(image, forKey: key as NSString)
    }
    
    // Bio caching
    func getBio(for key: String) -> String? {
        return bioCache.object(forKey: key as NSString) as String?
    }
    
    func setBio(_ bio: String, for key: String) {
        bioCache.setObject(bio as NSString, forKey: key as NSString)
    }
    
    // URL caching
    func getURL(for key: String) -> URL? {
        return urlCache.object(forKey: key as NSString) as URL?
    }
    
    func setURL(_ url: URL, for key: String) {
        urlCache.setObject(url as NSURL, forKey: key as NSString)
    }
}
