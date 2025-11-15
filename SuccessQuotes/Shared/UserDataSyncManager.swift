//
//  UserDataSyncManager.swift
//  SuccessQuotes
//
//  Created by Barbara on 23/09/2025.
//

import Foundation
import SwiftUI

#if canImport(FirebaseAuth) && canImport(FirebaseFirestore)
import FirebaseAuth
import FirebaseFirestore
#endif

// MARK: - User Data Model for Firestore
struct UserData: Codable {
    let uid: String
    var favoriteQuoteIds: [String]
    var savedQuotesOrder: [String]
    var lastSyncedAt: Date
    var deviceId: String
    
    init(uid: String, favoriteQuoteIds: [String] = [], savedQuotesOrder: [String] = []) {
        self.uid = uid
        self.favoriteQuoteIds = favoriteQuoteIds
        self.savedQuotesOrder = savedQuotesOrder
        self.lastSyncedAt = Date()
        self.deviceId = UIDevice.current.identifierForVendor?.uuidString ?? "unknown"
    }
}

class UserDataSyncManager: ObservableObject {
    // MARK: - Singleton
    static let shared = UserDataSyncManager()
    
    // MARK: - Properties
    @Published var isSyncing = false
    @Published var lastSyncDate: Date?
    @Published var syncError: String?
    
    #if canImport(FirebaseAuth) && canImport(FirebaseFirestore)
    private let db = Firestore.firestore()
    #endif
    private let userDefaultsManager = UserDefaultsManager.shared
    
    // MARK: - Constants
    private let userDataCollection = "user_data"
    private let lastSyncKey = "LastUserDataSync"
    
    private init() {
        #if canImport(FirebaseAuth) && canImport(FirebaseFirestore)
        // Listen for auth state changes
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            if let user = user {
                self?.syncUserDataOnSignIn(for: user.uid)
            }
        }
        #endif
    }
    
    // MARK: - Public Methods
    
    /// Sync user data when user signs in
    func syncUserDataOnSignIn(for uid: String) {
        #if canImport(FirebaseAuth) && canImport(FirebaseFirestore)
        Task {
            await downloadAndMergeUserData(for: uid)
        }
        #endif
    }
    
    /// Sync user data (upload local changes)
    func syncFavoriteQuotes(favoriteIds: [String], savedOrder: [String]) {
        #if canImport(FirebaseAuth) && canImport(FirebaseFirestore)
        guard let user = Auth.auth().currentUser else {
            print("❌ No authenticated user for sync")
            return
        }
        
        Task {
            await uploadUserData(for: user.uid, favoriteIds: favoriteIds, savedOrder: savedOrder)
        }
        #else
        // No-op for widget extension
        print("🔄 Sync not available in widget extension")
        #endif
    }
    
    // MARK: - Private Methods
    
    #if canImport(FirebaseAuth) && canImport(FirebaseFirestore)
    private func uploadUserData(for uid: String, favoriteIds: [String]? = nil, savedOrder: [String]? = nil) async {
        await MainActor.run { isSyncing = true }
        
        do {
            // Get current local data if not provided
            let currentFavorites = favoriteIds ?? userDefaultsManager.loadFavorites()
            let currentOrder = savedOrder ?? userDefaultsManager.loadSavedOrder()
            
            let userData = UserData(
                uid: uid,
                favoriteQuoteIds: currentFavorites,
                savedQuotesOrder: currentOrder
            )
            
            // Upload to Firestore
            try await db.collection(userDataCollection).document(uid).setData(from: userData)
            
            await MainActor.run {
                lastSyncDate = Date()
                UserDefaults.standard.set(lastSyncDate, forKey: lastSyncKey)
                syncError = nil
                print("✅ User data uploaded to Firebase: \(currentFavorites.count) favorites")
            }
            
        } catch {
            await MainActor.run {
                syncError = "Failed to upload user data: \(error.localizedDescription)"
                print("❌ Upload error: \(error)")
            }
        }
        
        await MainActor.run { isSyncing = false }
    }
    
    private func downloadAndMergeUserData(for uid: String) async {
        await MainActor.run { isSyncing = true }
        
        do {
            let document = try await db.collection(userDataCollection).document(uid).getDocument()
            
            if document.exists {
                let cloudUserData = try document.data(as: UserData.self)
                await mergeUserData(cloudData: cloudUserData)
                print("✅ User data downloaded from Firebase: \(cloudUserData.favoriteQuoteIds.count) favorites")
            } else {
                // No cloud data exists, upload current local data
                print("📤 No cloud data found, uploading local data to Firebase")
                await uploadUserData(for: uid)
            }
            
            await MainActor.run {
                lastSyncDate = Date()
                UserDefaults.standard.set(lastSyncDate, forKey: lastSyncKey)
                syncError = nil
            }
            
        } catch {
            await MainActor.run {
                syncError = "Failed to download user data: \(error.localizedDescription)"
                print("❌ Download error: \(error)")
            }
        }
        
        await MainActor.run { isSyncing = false }
    }
    
    private func mergeUserData(cloudData: UserData) async {
        // Get local data
        let localFavorites = userDefaultsManager.loadFavorites()
        let localOrder = userDefaultsManager.loadSavedOrder()
        let lastLocalSync = UserDefaults.standard.object(forKey: lastSyncKey) as? Date ?? Date.distantPast
        
        // Determine which data is newer
        let useCloudData = cloudData.lastSyncedAt > lastLocalSync
        
        var finalFavorites: [String]
        var finalOrder: [String]
        
        if useCloudData {
            // Cloud data is newer, but merge with local additions
            let combinedFavorites = Set(cloudData.favoriteQuoteIds).union(Set(localFavorites))
            finalFavorites = Array(combinedFavorites)
            
            // Merge order, prioritizing cloud order but adding any new local items
            var mergedOrder = cloudData.savedQuotesOrder
            for localId in localOrder {
                if !mergedOrder.contains(localId) {
                    mergedOrder.insert(localId, at: 0) // Add new items at the beginning
                }
            }
            finalOrder = mergedOrder
            
            print("📥 Using cloud data with local additions")
        } else {
            // Local data is newer or equal, merge cloud additions
            let combinedFavorites = Set(localFavorites).union(Set(cloudData.favoriteQuoteIds))
            finalFavorites = Array(combinedFavorites)
            
            // Merge order, prioritizing local order but adding any cloud items not present
            var mergedOrder = localOrder
            for cloudId in cloudData.savedQuotesOrder {
                if !mergedOrder.contains(cloudId) {
                    mergedOrder.append(cloudId)
                }
            }
            finalOrder = mergedOrder
            
            print("📱 Using local data with cloud additions")
        }
        
        // Save merged data locally
        await MainActor.run {
            userDefaultsManager.saveFavorites(finalFavorites)
            userDefaultsManager.saveSavedOrder(finalOrder)
            
            // Notify QuoteManager to reload favorites
            NotificationCenter.default.post(name: NSNotification.Name("UserDataSynced"), object: nil)
        }
        
        // Upload merged data to cloud to keep everything in sync
        if let user = Auth.auth().currentUser {
            await uploadUserData(for: user.uid, favoriteIds: finalFavorites, savedOrder: finalOrder)
        }
    }
    #endif
    
    // MARK: - Utility Methods
    
    func getLastSyncDate() -> Date? {
        return UserDefaults.standard.object(forKey: lastSyncKey) as? Date
    }
    
    func clearSyncData() {
        UserDefaults.standard.removeObject(forKey: lastSyncKey)
        lastSyncDate = nil
        syncError = nil
    }
}
