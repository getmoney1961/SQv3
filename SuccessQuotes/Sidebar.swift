//
//  Sidebar.swift
//  SuccessQuotes
//
//  Created by Barbara on 17/11/2024.
//

import SwiftUI

struct Sidebar: View {
    @State private var showingTimePicker = false  //
    @State private var showPayment = false
    
    var body: some View {
            VStack (alignment: .center) {
                VStack (alignment: .center) {
                    //Account
                    MenuItem(topText: "Your Account", bottomText: "dhjskaiensfllshias9023.appleid.com")
                    
                    Line()
                    
                    Line()
                    
                    //Upgrade
                    VStack (alignment: .center, spacing: 16) {
                        VStack (alignment: .center, spacing: 4) {
                            Text("Your Plan:")
                                .font(.system(size: 14, weight: .bold))
                                .textCase(.uppercase)
                            Text("Basic Plan")
                                .font(.system(size: 16))
                        }
                        HStack {
                            Spacer()
                            SidebarButton(label: "Get Full Version") {
                                // present payment page
                                showPayment = true
                            }
                            .sheet(isPresented: $showPayment) {
//                                Payment()
                            }
                            Spacer()
                        }
                    }
                    
                    Line()

                    
                }
                
                //Book
                VStack (alignment: .center, spacing: 16) {
                    //                    Text("The Book")
                    //                        .foregroundStyle(.black)
                    //                        .font(.system(size: 16))
                    //                        .padding(.bottom, 4)
                    //
                    //                    Image("sq")
                    //                        .resizable()
                    //                        .frame(width: 40, height: 60)
                    //
                    VStack (alignment: .center, spacing: 8) {
                        VStack (alignment: .center, spacing: 4) {
                            Text("Success Quotes")
                                .font(.system(size: 18, weight: .bold))
                            Text("A Paradigm Shift of Success")
                                .font(.system(size: 14))
                                .foregroundStyle(.gray)
                        }
                        
                        HStack {
                            Image(systemName: "star.fill")
                            Image(systemName: "star.fill")
                            Image(systemName: "star.fill")
                            Image(systemName: "star.fill")
                            Image(systemName: "star.fill")
                        }
                        .foregroundStyle(.yellow)
                        
                    }
                    HStack {
                        Spacer()
                    Link(destination: URL(string: "https://www.amazon.co.uk/Condensation-Book-Success-Quotes-Paradigm-ebook/dp/B07NBTGJ1V")!) {
                        HStack {
                            Image("amazon")
                                .resizable()
                                .frame(width: 12, height: 12)
                            Text("Get the Book")
                                .font(.system(size: 10, weight: .medium))
                        }
                        .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                        .foregroundStyle(.white)
                        .background(.black)
                        .cornerRadius(6)
                    }
                        Spacer()
                }
                }
                
                Line()

                VStack {
                    
                    //Feedback - email
                    Link(destination: URL(string: "mailto:successquotesbook@gmail.com?subject=Success%20Quotes%20App%20Feedback")!) {
                        Text("Get help or send feedback")
                            .foregroundStyle(.black)
                            .font(.system(size: 14))
                            .padding(EdgeInsets(top: 16, leading: 48, bottom: 16, trailing: 48))
                    }
                    .frame(maxWidth: .infinity)
                    .background(.gray.opacity(0.05))
                    .cornerRadius(36)
                    .padding(.horizontal)
                    
                    Line()
                }
                
            }
            .padding()
            .frame(maxWidth: getRect().width - 40, maxHeight: .infinity, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .leading)
//            .shadow(color: Color.gray.opacity(0.1), radius: 10, x: 0, y: 1)
            .background(.white)
//        .frame(maxWidth: 350, maxHeight: .infinity)
//        .background(.white)
//        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}

extension View {
    func getRect()->CGRect {
        return UIScreen.main.bounds
    }
}

struct SidebarButton: View {
    let label: String
    let action: () -> Void

    var body: some View {
        Button (action: action) {
        Text(label)
                .foregroundStyle(.black)
                .textCase(.uppercase)
                .font(.system(size: 14, weight: .medium))
                .padding(EdgeInsets(top: 16, leading: 48, bottom: 16, trailing: 48))
        }
        .background(.white)
        .cornerRadius(36)
        .overlay(
            RoundedRectangle(cornerRadius: 36)
                .stroke(.gray, lineWidth: 1)
        )
    }
}

struct MenuItem: View {
    let topText: String
    let bottomText: String

    var body: some View {
        VStack (alignment: .center, spacing: 4) {
            Text(topText)
                .font(.system(size: 14, weight: .medium))
                .textCase(.uppercase)
            Text(bottomText)
                .font(.system(size: 14))
                .kerning(0.7)
        }
    }
}

struct MenuItemImage: View {
    let image: String
    let text: String

    var body: some View {
        HStack {
            Image(systemName: image)
            Text(text)
        }
    }
}

struct Line: View {
        var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.1))
            .frame(height: 1)
            .padding(.vertical)
        }
    }


#Preview {
    Sidebar()
}
