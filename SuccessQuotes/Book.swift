////
////  Book.swift
////  SuccessQuotes
////
////  Created by Barbara on 12/11/2024.
////
//
//import SwiftUI
//
//
//
//struct Book: View {
//    var body: some View {
//            ZStack {
//                Color.gray.opacity(0.2).ignoresSafeArea(.all)
//                VStack {
//                    VStack {
//                        Image("sq")
//                            .resizable()
//                            .frame(width: 200, height: 300)
//                            .padding()
//                        HStack {
//                            Text("12.85 x 0.97 x 19.84 cm")
//                                .font(.system(size: 12))
//                            Spacer()
//                            Text("Writen by S Darling")
//                                .font(.system(size: 12, weight: .bold))
//                        }
//                        .padding(.horizontal)
//                        .foregroundStyle(.gray.opacity(0.5))
//                        
//                        HorizontalLine()
//                        
//                        VStack (spacing: 6) {
//                            Text("Success Quotes")
//                                .font(.system(size: 18, weight: .bold))
//                            Text("A Paradigm Shift of Success")
//                                .font(.system(size: 14))
//                                .foregroundStyle(.gray)
//                            
//                            Ratings()
//                        }
//                        .padding(8)
//                        .frame(maxWidth: .infinity)
//                        //            .background(.gray.opacity(0.07))
//                        //            .overlay(
//                        //                RoundedRectangle(cornerRadius: 0)
//                        //                    .stroke(.gray.opacity(0.07), lineWidth: 1)
//                        //            )
//                    }
//                    
//                    
//                    VStack {
//                        HorizontalLine()
//                        HStack (alignment: .center, spacing: 16) {
//                            BookInfo(image: "calendar", toptext: "31 Jan, 2019", bottomtext: "Published")
//                            VerticalLine()
//                            
//                            
//                            BookInfo(image: "trophy", toptext: "1,000+", bottomtext: "Goodreads Ratings")
//                            VerticalLine()
//                            
//                            BookInfo(image: "globe", toptext: "English", bottomtext: "Language")
//                            VerticalLine()
//                            
//                            BookInfo(image: "book", toptext: "167", bottomtext: "Pages")
//                        }
//                        .frame(height: 65)
//                        .padding(8)
//                        
//                        
//                        HorizontalLine()
//
//                        BookDescription()
//                        
//                        HorizontalLine()
//                        HStack {
//                            Spacer()
//                            Button(action: {
//                                
//                            }) {
//                                HStack {
//                                    Image("amazon")
//                                        .resizable()
//                                        .frame(width: 12, height: 12)
//                                    Text("Buy on Amazon")
//                                        .font(.system(size: 10, weight: .medium))
//                                }
//                                .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
//                                .foregroundStyle(.white)
//                                .background(.black)
//                                .cornerRadius(6)
//                                .padding(.horizontal, 24)
//                            }
//                        }
//                        Spacer()
//                    }
//                    .background(.white)
//                }
//                //            .padding(.horizontal)
//            }
//    }
//}
//
//struct Ratings: View {
//    var body: some View {
//        HStack {
//            Image(systemName: "star.fill")
//            Image(systemName: "star.fill")
//            Image(systemName: "star.fill")
//            Image(systemName: "star.fill")
//            Image(systemName: "star.leadinghalf.filled")
//        }
//        .foregroundStyle(.yellow)
//    }
//}
//
//struct BookInfo: View {
//    let image: String
//    let toptext: String
//    let bottomtext: String
//
//    var body: some View {
//        VStack {
//            Image(systemName: image)
//                .resizable()
//                .frame(width: 20, height: 20)
//                .foregroundStyle(.gray)
//
//            Text(toptext)
//                .font(.system(size: 12, weight: .bold))
//                .lineLimit(1)
//                .multilineTextAlignment(.center)
//
//            Text(bottomtext)
//                .foregroundStyle(.gray)
//                .font(.system(size: 12))
//                .lineLimit(1)
//                .multilineTextAlignment(.center)
//        }
////        .padding(.horizontal)
//        .frame(alignment: .leading)
//    }
//}
//
//struct BookDescription: View {
//    var body: some View {
//        Text("What is Success? Despite all the endless books, articles and debate about success, are you still wondering what success is? The Webster dictionary defines success as getting or achieving wealth, respect, or fame. If success is about gaining wealth, respect or fame, how much wealth do you need to be successful, how much respect or how much fame do you need to be successful? What if you decide to devote your life to serving mankind, making a positive impact on society, raising children of character or serving your country in humility? Does it mean you are less successful? No. Success is doing the best you can with what you have wherever you are in life. This book is compiled in quotes based on the concept that success can be cultivated. “Every single one of us is capable of achieving our highest potential.” Anders Ericsson“The size of your success is measured by the strength of your desire, the size of your dream, and how you handle disappointment along the way” – Robert KiyosakiChange your perspective on success, learn what success really means, and what strategies you need to be successful from a selection of quotes. The right quotation can shift your thinking, alter your way of seeing the world and give you a sudden and great revelation. Success Quotes: A Paradigm Shift of Success will help you to understand that with effort, persistence and the right strategy you can succeed.This book is an invaluable resource for anyone including writers, teachers, public speakers, coaches, and business people. It is also for anyone looking for inspiration, motivation or anyone who needs to communicate a positive message to an audience.")
//            .lineLimit(8)
//            .padding(.horizontal)
//            .padding(.top, 2)
//    }
//}
//
//
//struct VerticalLine: View {
//    var body: some View {
//        Rectangle()
//            .fill(Color.gray.opacity(0.2))
//            .frame(width: 1, height: 60)
//    }
//}
//
//struct HorizontalLine: View {
//    var body: some View {
//        Rectangle()
//            .fill(Color.gray.opacity(0.2))
//            .frame(width: .infinity, height: 1)
//    }
//}
//#Preview {
//    Book()
//}
