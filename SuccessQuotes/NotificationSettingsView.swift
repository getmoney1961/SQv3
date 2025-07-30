//
//  NotificationSettingsView.swift
//  SuccessQuotes
//
//  Created by Barbara on 05/01/2025.
//

import SwiftUI

struct NotificationSettingsView: View {
    @EnvironmentObject private var notificationManager: NotificationManager
    @EnvironmentObject private var userDefaultsManager: UserDefaultsManager
    @State private var isNotificationsEnabled: Bool = false
    @State private var notificationTime: Date = Date()
    @State private var showingTestNotification = false
    @State private var notificationStatus: UNAuthorizationStatus = .notDetermined
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Daily Notifications")) {
                    Toggle("Enable Daily Notifications", isOn: $isNotificationsEnabled)
                        .onChange(of: isNotificationsEnabled) { newValue in
                            if newValue {
                                notificationManager.requestNotificationPermission { granted in
                                    if granted {
                                        notificationManager.scheduleDailyNotification(at: notificationTime)
                                    } else {
                                        isNotificationsEnabled = false
                                    }
                                }
                            } else {
                                notificationManager.cancelAllNotifications()
                            }
                        }
                    
                    if isNotificationsEnabled {
                        DatePicker("Notification Time", selection: $notificationTime, displayedComponents: .hourAndMinute)
                            .onChange(of: notificationTime) { newTime in
                                if isNotificationsEnabled {
                                    notificationManager.scheduleDailyNotification(at: newTime)
                                }
                            }
                    }
                    
                    // Show notification status
                    HStack {
                        Text("Status")
                        Spacer()
                        Text(statusText)
                            .foregroundColor(statusColor)
                    }
                }
                
                Section(header: Text("Testing")) {
                    Button("Send Test Notification") {
                        notificationManager.sendTestNotification()
                        showingTestNotification = true
                    }
                    .disabled(!isNotificationsEnabled)
                }
                
                Section(header: Text("About")) {
                    Text("Daily notifications will be sent at 9:00 AM with today's quote of the day. Tapping the notification will open the app and show you the quote.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Notifications")
            .onAppear {
                let settings = userDefaultsManager.loadNotificationSettings()
                isNotificationsEnabled = settings.enabled
                notificationTime = settings.time
                
                // Check current notification status
                notificationManager.checkNotificationStatus { status in
                    notificationStatus = status
                }
            }
        }
        .alert("Test Notification Sent", isPresented: $showingTestNotification) {
            Button("OK") { }
        } message: {
            Text("A test notification has been scheduled and will appear in 5 seconds.")
        }
    }
    
    private var statusText: String {
        switch notificationStatus {
        case .authorized:
            return "Allowed"
        case .denied:
            return "Denied"
        case .notDetermined:
            return "Not Determined"
        case .provisional:
            return "Provisional"
        case .ephemeral:
            return "Ephemeral"
        @unknown default:
            return "Unknown"
        }
    }
    
    private var statusColor: Color {
        switch notificationStatus {
        case .authorized:
            return .green
        case .denied:
            return .red
        case .notDetermined:
            return .orange
        default:
            return .gray
        }
    }
}

#Preview {
    NotificationSettingsView()
        .environmentObject(NotificationManager.shared)
        .environmentObject(UserDefaultsManager.shared)
} 