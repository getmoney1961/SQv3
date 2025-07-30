//
//  NotificationRejection.swift
//  SuccessQuotes
//
//  Created by Barbara on 21/07/2025.
//

import SwiftUI

struct NotificationRejection: View {
    var onContinue: () -> Void
    @StateObject private var notificationManager = NotificationManager.shared
    @State private var hasCheckedPermission = false
    @State private var isCheckingPermission = false
    @State private var showSuccessMessage = false
    
    var body: some View {
        ZStack {
            // Background
            Color.black.ignoresSafeArea()
            
            VStack {
//                Spacer()
                
                // Title
                Text("Success Quotes works best with reminders")
                    .font(.custom("Helvetica Now Display Medium", size: 22))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.top, 60)
                
                Spacer()
                
                // Bell Icon
                Image("bell")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .foregroundColor(Color.white.opacity(0.08))
                    .padding(.vertical, 20)
                
                Spacer()
                
                VStack (spacing: 24) {
                    // Subtitle
                    Text("Open Settings to enable notifications, you can control how you'd like to be notified in the app.")
                        .font(.custom("Helvetica Now Display", size: 14))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                    
                    // Additional info
                    Text("You can always enable notifications later in the app settings.")
                        .font(.custom("Helvetica Now Display", size: 12))
                        .foregroundColor(.onboardgrey)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                    
                    // Show checking status
                    if isCheckingPermission {
                        HStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                            Text("Checking notification settings...")
                                .font(.custom("Helvetica Now Display", size: 12))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 32)
                    }
                    
                    // Show success message
                    if showSuccessMessage {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Notifications enabled!")
                                .font(.custom("Helvetica Now Display", size: 12))
                                .foregroundColor(.green)
                        }
                        .padding(.horizontal, 32)
                    }
                    
                    VStack (spacing: 16) {
                        // Go to settings button
                        Button(action: {
                            // Open app settings
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text("Go to settings")
                                .font(.custom("Inter-Medium", size: 18))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(20)
                                .background(Color.white)
                                .cornerRadius(32)
                                .padding(.horizontal, 16)
                        }
                        
                        // Manual refresh button (for testing)
//                        Button(action: {
//                            hasCheckedPermission = false
//                            checkNotificationPermission()
//                        }) {
//                            Text("Check Again")
//                                .font(.custom("Inter-Medium", size: 14))
//                                .foregroundColor(.white)
//                                .frame(maxWidth: .infinity)
//                                .padding(16)
//                                .background(Color.gray.opacity(0.3))
//                                .cornerRadius(32)
//                                .padding(.horizontal, 16)
//                        }
                        
                        // "I DON'T WANT NOTIFICATIONS" text
                        Button(action: {
                            onContinue()
                        }) {
                            Text("I DON'T WANT NOTIFICATIONS")
                                .font(.custom("Inter-Medium", size: 14))
                                .foregroundColor(Color.rejectiongrey)
                                .underline()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .padding(.horizontal, 16)
                        }
                    }
                    .padding(.bottom)
                }
            }
        }
        .onAppear {
            // Check permission status when view appears
            checkNotificationPermission()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            // Check permission status when app becomes active
            print("📱 App became active, checking permissions...")
            hasCheckedPermission = false // Reset flag to allow re-checking
            checkNotificationPermission()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            // Alternative way to detect when app comes to foreground
            print("📱 App will enter foreground, checking permissions...")
            hasCheckedPermission = false // Reset flag to allow re-checking
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                checkNotificationPermission()
            }
        }
    }
    
    private func checkNotificationPermission() {
        print("🔍 Checking notification permission...")
        isCheckingPermission = true
        notificationManager.areNotificationsProperlySetUp { isSetUp in
            DispatchQueue.main.async {
                isCheckingPermission = false
                print("📱 Notification setup status: \(isSetUp)")
                if isSetUp && !hasCheckedPermission {
                    print("✅ Notifications are properly set up, advancing...")
                    hasCheckedPermission = true
                    // Schedule the notification and advance to next screen
                    notificationManager.scheduleDailyNotification()
                    
                    // Show success message
                    showSuccessMessage = true
                    
                    // Add a small delay to show the success state
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        print("🚀 Advancing to next screen...")
                        onContinue()
                    }
                } else {
                    print("❌ Notifications not set up or already checked")
                }
            }
        }
    }
}

#Preview {
    NotificationRejectionPreviewWrapper()
}

struct NotificationRejectionPreviewWrapper: View {
    @State private var showPaymentOnboard = false

    var body: some View {
        if showPaymentOnboard {
            PaymentOnboard(onContinue: {})
        } else {
            NotificationRejection(onContinue: {showPaymentOnboard = true })
        }
    }
}
