//
//  FeatureThreeText.swift
//  SuccessQuotes
//
//  Created by Barbara on 26/07/2025.
//

import SwiftUI

struct FeatureThreeText: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Discover, Save, and Share ")
                .foregroundColor(Color.yella)
                .font(.custom("Helvetica Now Display Medium", size: 22)) +
            Text("quotes that")
                .foregroundColor(.featurewhite)
                .font(.custom("Helvetica Now Display Medium", size: 22)) +
            Text(" move you ")
                .foregroundColor(.featurewhite)
                .font(.custom("Helvetica Now Display Medium", size: 22)) +
            Text("+ more")
                .foregroundColor(.featurewhite)
                .font(.custom("Helvetica Now Display Medium", size: 22))
        }
        .padding(.horizontal, 22)
    }
}

#Preview {
    FeatureThreeText()
}
