//
//  RootView.swift
//  SuccessQuotes
//
//  Created by Barbara on 22/07/2025.
//

import SwiftUI

struct RootView: View {
    @State private var step: OnboardingStep = .intro
//    @State private var notificationsAllowed: Bool? = nil

    var body: some View {
        switch step {
        case .intro:
//            Intro(onContinue: {})
            Intro(onContinue: { step = .welcome })
        case .welcome:
//            Welcome(onContinue: {})
            Welcome(onContinue: { step = .features })
//        case .featureOne:
//            FeatureOne(onContinue: { step = .featureTwo })
//        case .featureTwo:
//            FeatureTwo(onContinue: { step = .featureThree })
        case .features:
//            Features(onContinue: { step = .widgetSetup })
            Features(onContinue: { step = .notificationsSetup })
        case .notificationsSetup:
            NotificationsSetup(
                onAllowed: { step = .widgetSetup },
                onDenied: { step = .notificationRejection }
            )
        case .notificationRejection:
//            NotificationRejection(onContinue: {})
            NotificationRejection(onContinue: { step = .widgetSetup })
        case .widgetSetup:
            WidgetSetup(onContinue: { step = .paymentOnboard })
        case .paymentOnboard:
//            PaymentOnboard(onContinue: {})
            PaymentOnboard(onContinue: { step = .thankYou })
        case .thankYou:
            ThankYou(onContinue: { step = .mainContent })
        case .mainContent:
            ContentView()
        }
    }
}

#Preview {
    RootView()
}


enum OnboardingStep {
    case intro
    case welcome
//    case featureOne
//    case featureTwo
//    case featureThree
    case features
    case notificationsSetup
    case notificationRejection
    case widgetSetup
    case paymentOnboard
    case thankYou
    case mainContent
}
