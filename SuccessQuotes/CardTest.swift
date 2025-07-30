//
//  CardTest.swift
//  WinningYear
//
//  Created by Barbara on 02/12/2024.
//

import SwiftUI

struct CardTest: View {
    let context: String
    let isLoading: Bool
    var onDismiss: () -> Void
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
        VStack (alignment: .leading, spacing: 0) {
            HStack {
                Text("Context")
                    .font(.custom("NewYork-Regular", size: 24))
                Spacer()
                Button(action: onDismiss) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                    //                        .padding(EdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14))
                        .background(.black)
                        .cornerRadius(24)
                }
            }
            .padding()

            Text(context)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
        }
            Button(action: {
                
            }) {
                HStack {
                    Spacer()
                    Text("Share")
                    Image("share")
                        .resizable()
                        .frame(width: 14, height: 16)
                    Spacer()
                }
                .foregroundStyle(.white)
                .padding(EdgeInsets(top: 14, leading: 20, bottom: 14, trailing: 20))
                .background(.black.opacity(0.9))
                .cornerRadius(24)
            }
            .padding()
        }
        .padding()
            }
        }


        #Preview {
            CardTest(
                context: "This quote was said by Steve Jobs during his famous Stanford commencement speech in 2005. He was reflecting on his experiences and sharing life lessons with graduating students.",
                isLoading: false,
                onDismiss: {}  // Add empty closure for preview
            )
        }

