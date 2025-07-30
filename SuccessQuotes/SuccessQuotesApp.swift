//
//  SuccessQuotesApp.swift
//  SuccessQuotes
//
//  Created by Barbara on 17/10/2024.
//

import SwiftUI
import UserNotifications
import BackgroundTasks

@main
struct SuccessQuotesApp: App {
    @StateObject private var quoteManager = QuoteManager()
    @StateObject private var notificationManager = NotificationManager.shared
    
    init() {
        // Remove existing notifications and set up notification delegate
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().delegate = NotificationDelegate.shared
        
        // Register background task
        registerBackgroundTasks()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
//            RootView()
                .environmentObject(quoteManager)
                .environmentObject(notificationManager)
                .preferredColorScheme(.light)
                .onOpenURL { url in
                    // Handle deep links
                    _ = notificationManager.handleDeepLink(url)
                }
        }
    }
    
    private func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.barbara.SuccessQuotes.quoterefresh", using: nil) { task in
            self.handleQuoteRefresh(task: task as! BGAppRefreshTask)
        }
    }
    
    private func handleQuoteRefresh(task: BGAppRefreshTask) {
        // Schedule the next refresh
        scheduleQuoteRefresh()
        
        // Check if quote of the day needs updating
        let quoteManager = QuoteManager.shared
        if quoteManager.needsQuoteOfTheDayUpdate() {
            print("🔄 Background task: Updating quote of the day...")
            quoteManager.checkAndUpdateQuoteOfTheDay()
        }
        
        task.setTaskCompleted(success: true)
    }
    
    private func scheduleQuoteRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.barbara.SuccessQuotes.quoterefresh")
        request.earliestBeginDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("✅ Background quote refresh scheduled")
        } catch {
            print("❌ Failed to schedule background quote refresh: \(error)")
        }
    }
}

// MARK: - Notification Delegate
class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationDelegate()
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Show notification even when app is in foreground
        completionHandler([.banner, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle notification tap
        if let deepLink = response.notification.request.content.userInfo["deepLink"] as? String {
            if deepLink == "quoteOfTheDay" {
                NotificationCenter.default.post(name: .navigateToQuoteOfTheDay, object: nil)
            }
        }
        completionHandler()
    }
}
