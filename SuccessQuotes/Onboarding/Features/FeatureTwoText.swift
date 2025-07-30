//
//  FeatureTwoText.swift
//  SuccessQuotes
//
//  Created by Barbara on 26/07/2025.
//

import SwiftUI

struct FeatureTwoText: View {
    var body: some View {
        VStack (alignment: .leading) {
            HStack (spacing: 0)  {
                Text("Dig deeper into ")
                    .foregroundColor(.featurewhite)
                    .font(.custom("Helvetica Now Display Medium", size: 22))
                Text("quote meanings and")
                    .foregroundColor(Color("yella"))
                    .font(.custom("Helvetica Now Display Medium", size: 22))
                Spacer()
            }
            HStack (spacing: 0)  {
                Text("origins")
                    .foregroundColor(Color("yella"))
                    .font(.custom("Helvetica Now Display Medium", size: 22))
                Text(" with our context tool")
                    .foregroundColor(.featurewhite)
                    .font(.custom("Helvetica Now Display Medium", size: 22))
                Spacer()
            }
        }
        .padding(.horizontal, 22)
    }
}

#Preview {
    FeatureTwoText()
}
