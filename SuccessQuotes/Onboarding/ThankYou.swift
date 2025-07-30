//
//  ThankYou.swift
//  SuccessQuotes
//
//  Created by Barbara on 21/07/2025.
//

import SwiftUI

struct ThankYou: View {
    var onContinue: () -> Void
    var body: some View {
                VStack(spacing: 32) {
                    Spacer()
                    Image(systemName: "checkmark.seal.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.orang)
                    Text("Thank You!")
                        .font(.custom("EditorialNew-Ultralight", size: 36))
                        .foregroundColor(.orang)
                    Text("Your purchase was successful.\nEnjoy unlimited access to Success Quotes!")
                        .font(.custom("Inter-Regular", size: 18))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
                .background(Color.black.edgesIgnoringSafeArea(.all))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        onContinue()
                    }
                }
            }
        }    

#Preview {
    ThankYou(onContinue: {})
}
