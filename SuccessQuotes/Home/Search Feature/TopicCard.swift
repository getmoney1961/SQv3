//
//  TopicCard.swift
//  SuccessQuotes
//
//  Created by Barbara on 08/11/2024.
//

import SwiftUI

struct TopicCard: View {
    let topic: String
    var body: some View {
        VStack {
            Text(topic)
//                .font(.custom("NewYork-Regular", size: 14))
//                .fontWeight(.medium)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 200)

        }
        .background(Color.white) // Add this to ensure the entire card is tappable
        .clipShape(RoundedRectangle(cornerRadius: 16))
        //            .overlay(
        //                RoundedRectangle(cornerRadius: 24)
        //                    .stroke(.gray.opacity(0.05), lineWidth: 2)
        //            )
        .shadow(color: Color.gray.opacity(0.05), radius: 10, x: 0, y: 1)
//        .padding(.horizontal, 4) // Reduce horizontal padding here
    }
}

struct TopicCard_Previews: PreviewProvider {
    static var previews: some View {
        TopicCard(topic: "Inspiration")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
