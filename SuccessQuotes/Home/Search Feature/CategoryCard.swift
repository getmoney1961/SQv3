//
//  CategoryCard.swift
//  SuccessQuotes
//
//  Created by Barbara on 28/12/2024.
//

import SwiftUI

struct CategoryCard: View {
    let category: String
    
    // Function to get image name based on category
    private func imageForCategory(_ category: String) -> String {
        switch category.lowercased() {
        case "activists":
            return "activists"
        case "actors":
            return "actors"
        case "athletes":
            return "athlethes"
        case "philosophers":
            return "philosopher"
        case "authors and writers":
            return "writer"
        case "scientists & technologists":
            return "scientist"
        case "business leaders and entrepreneurs":
            return "business"
        case "historical figures", "historical figures & politicians":
            return "historical"
        case "motivational speakers":
            return "speaker"
        case "religious and spiritual leaders":
            return "spiritual"
        case "psychologists":
            return "psychology"
        case "polymaths":
            return "polymath"
        case "proverbs":
            return "book"
        default:
            return "default-category" // Your default image
        }
    }
    
    var body: some View {
        VStack {
        ZStack {
            ZStack {
                Image(imageForCategory(category))
                    .resizable()
//                    .scaledToFill()
//                    .frame(maxWidth: .infinity, maxHeight: 250)


                //                .frame(height: 80)
                //                .padding()
                //                .padding(.top)
                Rectangle()
                    .fill(.black)
                    .opacity(0.05)
            }

            VStack {
                Spacer()
                Text(category)
                    .font(.custom("EditorialNew-Regular", size: 16))
                //                .font(.custom("NewYork-Regular", size: 14))
                //                .fontWeight(.medium)
//                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }

        }

    }
        .frame(maxWidth: .infinity, maxHeight: 240)
        .background(Color.white) // Add this to ensure the entire card is tappable
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.gray.opacity(0.05), radius: 10, x: 0, y: 1)    }
}

// ... rest of the file remains the same ...

#Preview {
    ScrollView {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            CategoryCard(category: "Activists")
            CategoryCard(category: "Actors")
            CategoryCard(category: "Athletes")
            CategoryCard(category: "Authors")
            CategoryCard(category: "Authors and Writers")
            CategoryCard(category: "Business Leaders and Entrepreneurs")
            CategoryCard(category: "Coaches")
        }
        .padding()
    }
    .background(Color.gray.opacity(0.1))
}
