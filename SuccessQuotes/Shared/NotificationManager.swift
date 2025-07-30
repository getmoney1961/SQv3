//
//  NotificationManager.swift
//  SuccessQuotes
//
//  Created by Barbara on 05/01/2025.
//

import Foundation
import UserNotifications
import SwiftUI

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    private let userDefaultsManager = UserDefaultsManager.shared
    
    private init() {}
    
    // MARK: - Notification Permission
    func requestNotificationPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    self.userDefaultsManager.saveNotificationSettings(enabled: true)
                }
                completion(granted)
            }
        }
    }
    
    // MARK: - Schedule Daily Notification
    func scheduleDailyNotification(at time: Date = Date()) {
        // Remove existing notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = "Your Daily Inspiration"
        content.body = "Start your day with today's quote of the day"
        content.sound = .default
        content.badge = 1
        
        // Add deep link to quote of the day
        content.userInfo = ["deepLink": "quoteOfTheDay"]
        
        // Create date components for 9am
        var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
        dateComponents.hour = 9
        dateComponents.minute = 0
        
        // Create trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // Create request
        let request = UNNotificationRequest(
            identifier: "dailyQuoteNotification",
            content: content,
            trigger: trigger
        )
        
        // Schedule notification
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("✅ Daily notification scheduled successfully for 9:00 AM")
                self.userDefaultsManager.saveNotificationSettings(enabled: true, time: time)
            }
        }
    }
    
    // MARK: - Cancel Notifications
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        userDefaultsManager.saveNotificationSettings(enabled: false)
    }
    
    // MARK: - Check Notification Status
    func checkNotificationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus)
            }
        }
    }
    
    // MARK: - Check if notifications are properly set up
    func areNotificationsProperlySetUp(completion: @escaping (Bool) -> Void) {
        checkNotificationStatus { status in
            let isAuthorized = status == .authorized
            print("🔐 Notification status: \(status.rawValue)")
            print("📱 Is authorized: \(isAuthorized)")
            // Only check system permission, not app internal flag
            completion(isAuthorized)
        }
    }
    
    // MARK: - Test Notification (for debugging)
    func sendTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Test Notification"
        content.body = "This is a test notification for the quote of the day"
        content.sound = .default
        content.userInfo = ["deepLink": "quoteOfTheDay"]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "testNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Error sending test notification: \(error.localizedDescription)")
            } else {
                print("✅ Test notification scheduled successfully")
            }
        }
    }
    
    // MARK: - Handle Deep Link
    func handleDeepLink(_ url: URL) -> Bool {
        guard url.scheme == "successquotes" else { return false }
        
        if url.host == "quoteOfTheDay" {
            // Navigate to quote of the day
            NotificationCenter.default.post(name: .navigateToQuoteOfTheDay, object: nil)
            return true
        }
        
        return false
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let navigateToQuoteOfTheDay = Notification.Name("navigateToQuoteOfTheDay")
} 