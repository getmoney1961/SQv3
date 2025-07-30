//
//  Splash.swift
//  SuccessQuotes
//
//  Created by Barbara on 15/07/2025.
//

import SwiftUI

struct Splash: View {
    var onContinue: () -> Void
    var body: some View {
        Image("launchscreenalt")
            .resizable()
            .ignoresSafeArea()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    onContinue()
                }
            }
    }
}

#Preview {
    Splash(onContinue: {})
}
