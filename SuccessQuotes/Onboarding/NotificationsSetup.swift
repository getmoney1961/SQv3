//
//  NotificationsSetup.swift
//  SuccessQuotes
//
//  Created by Barbara on 14/07/2025.
//

import SwiftUI

struct NotificationsSetup: View {
    var onAllowed: () -> Void
    var onDenied: () -> Void
    @StateObject private var notificationManager = NotificationManager.shared
    @State private var isRequesting = false
    
    var body: some View {
        ZStack {
            Color.onboardbg
                .ignoresSafeArea()
            
            ZStack {
                // Placeholder for phone + notifications image
                ZStack {
                    Image("iphonenotifi") // Replace with your custom image if available
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 375)
//                        .padding(.bottom, 32)
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black, Color.black.opacity(0.1)]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black, Color.black.opacity(0.05)]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black, Color.black.opacity(0.05)]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    .ignoresSafeArea()
                }
//                .frame(height: 750) // Add this line to constrain the ZStack height

                
            VStack(spacing: 32) {
                Spacer()

                VStack(spacing: 16) {
                    Text("Get inspired everyday with\ndaily reminders")
                        .font(.custom("EditorialNew-Light", size: 22)) // Use your serif font
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    Text("3 months from now you will thank yourself 😉")
                        .font(.custom("Helvetica Now Display", size: 14))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
                
                HStack(alignment: .top, spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 22, height: 22)
                        Text("1")
                            .font(.custom("Helvetica Now Display", size: 13))
                            .foregroundColor(.black)
                    }
                    Text("Please tap \"Allow Notifications\" in the next prompt to setup daily reminders")
                        .foregroundColor(.onboardgrey)
                        .font(.custom("Helvetica Now Display", size: 14))
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 40)
                
                Button(action: {
                    isRequesting = true
                    notificationManager.requestNotificationPermission { granted in
                        isRequesting = false
                        if granted {
                            // Schedule the daily notification
                            notificationManager.scheduleDailyNotification()
                            onAllowed()
                        } else {
                            onDenied()
                        }
                    }
                }) {
                    HStack {
                        if isRequesting {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                .scaleEffect(0.8)
                        }
                        Text(isRequesting ? "Requesting..." : "Turn on motivation")
                            .font(.custom("Inter-Medium", size: 14))
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity, minHeight: 56)
                    .background(Color.white)
                    .cornerRadius(40)
                }
                .disabled(isRequesting)
                .padding(.horizontal, 32)
                .padding(.bottom, 24)
            }
        }
        }
    }
}


#Preview {
    NotificationsSetupPreviewWrapper()
}

struct NotificationsSetupPreviewWrapper: View {
    @State private var showWidgetSetup = false

    var body: some View {
        if showWidgetSetup {
            WidgetSetup(onContinue: {})
        } else {
            NotificationsSetup(onAllowed: {showWidgetSetup = true}, onDenied: {}
            )

        }
    }
}
