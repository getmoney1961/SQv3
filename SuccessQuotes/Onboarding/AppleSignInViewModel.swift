//
//  AppleSignInViewModel.swift
//  SuccessQuotes
//
//  Created by Barbara on 23/07/2025.
//

import Foundation
import AuthenticationServices

class AppleSignInViewModel: NSObject, ObservableObject {
    @Published var userIdentifier: String?
    @Published var error: Error?

    func startSignInWithAppleFlow() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}

extension AppleSignInViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            self.userIdentifier = appleIDCredential.user
            // You can also access email, fullName, etc. here
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.error = error
    }
}

extension AppleSignInViewModel: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        // Replace with your app's main window
        UIApplication.shared.windows.first { $0.isKeyWindow }!
    }
}
