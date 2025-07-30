//
//  FeatureOneText.swift
//  SuccessQuotes
//
//  Created by Barbara on 26/07/2025.
//

import SwiftUI

struct FeatureOneText: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("The world’s largest library ")
                .foregroundColor(Color.yella)
                .font(.custom("Helvetica Now Display Medium", size: 22))
            + Text("on success always in your pocket")
                .foregroundColor(Color.featurewhite)
                .font(.custom("Helvetica Now Display Medium", size: 22))
        }
        .padding(.horizontal, 22)
    }
}

#Preview {
    FeatureOneText()
}
