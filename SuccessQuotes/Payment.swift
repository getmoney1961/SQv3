////
////  Payment.swift
////  SuccessQuotes
////
////  Created by Barbara on 21/11/2024.
////
//
//import SwiftUI
//import StoreKit
//
//struct Payment: View {
//    @Environment(\.dismiss) var dismiss
//    @State private var selectedPlan: PlanType = .yearly
//    @State private var isPulsating = false // Add this state
//    @State private var limitedPlanOpacity = 0.0 // Add this state variable
//
//    enum PlanType: String {
//        case saver = "Saver plan"
//        case yearly = "1 Year Access"
//        case lifetime = "Lifetime Access"
//        
//        var price: Decimal {
//            switch self {
//            case .saver: return 4.99
//            case .yearly: return 19.99
//            case .lifetime: return 75.99
//            }
//        }
//        
//        var subtitle: String? {
//            switch self {
//            case .saver: return "Only £4.99/month, billed monthly, cancel anytime."
//            case .yearly: return "Only £1.66/month, billed annually, cancel anytime."
//            case .lifetime: return "Pay once, keep forever"
//            }
//        }
//        
//        static var features: [String] {
//            [
//                "Access 1000+ wisdom on the world's biggest library on success from the world's most successful people",
//                "Search through 1000s of quotes, authors and topics",
//                "Context - get meaning behind quotes",
//                "Quotes you won't find anywhere else",
//                "Lock screen widgets",
//                "No Ads Forever",
//                "Categories",
//                "Add your own quotes",
//                "Future Pro features"
//            ]
//        }
//    }
//    
//    var body: some View {
//        VStack {
//            
//            Button("Continue with limited plan") {
//                   dismiss()
//               }
//               .font(.system(size: 12))
//               .foregroundColor(.gray.opacity(0.5))
//               .opacity(limitedPlanOpacity) // Use opacity binding
//               .padding(.top, 16)
//               .padding(.bottom, 2)
//            // Header
//            Text("Invest in your mindset")
//                .font(.custom("EditorialNew-Regular", size: 32))
////                .font(.system(size: 28))
//                .lineLimit(3)
//                .multilineTextAlignment(.center)
//
//            VStack {
//                ScrollView (showsIndicators: false){
//                    VStack(spacing: 24) {
//                        // Features List
//                        VStack(alignment: .leading, spacing: 16) {
//                            ForEach(Feature.all) { feature in
//                                HStack(spacing: 12) {
//                                    Image(systemName: feature.icon)
//                                        .foregroundColor(.gray)
//                                        .frame(width: 24) // Fixed width for alignment
//                                    Text(feature.text)
//                                        .font(.system(size: 14))
//                                }
//                            }
//                        }
////                        .padding(.horizontal)
//                        
//                    }
//                }
//                .padding(.vertical, 25)
//                .padding(.horizontal, 16)
////                .background(.gray.opacity(0.1))
//                .cornerRadius(24)
////                .overlay(
////                    RoundedRectangle(cornerRadius: 24)
////                        .stroke(.gray.opacity(0.3), lineWidth: 2)
////                )
//                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
//                
//                // Payment section
//                VStack(spacing: 12) {
//                    // Plans
//                    VStack(spacing: 12) {
//                        ForEach([PlanType.saver, .yearly, .lifetime], id: \.self) { plan in
//                              PlanButton(
//                                  title: plan.rawValue,
//                                  price: formatPrice(plan.price),
//                                  subtitle: plan.subtitle,
//                                  isSelected: selectedPlan == plan
//                              ) {
//                                  selectedPlan = plan
//                              }
//                          }
//                      }
//                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
//
//                    
//                    // Continue Button
//                    Button(action: {
//                          // Handle purchase
//                      }) {
//                          Text("Continue")
//                              .font(.system(size: 18, weight: .semibold))
//                              .foregroundColor(.black)
//                              .frame(maxWidth: .infinity)
//                              .padding(.vertical, 16)
//                              .background(Color.white)
//                              .cornerRadius(30)
//                              .scaleEffect(isPulsating ? 1.05 : 1)
//                              .animation(
//                                  Animation.easeInOut(duration: 0.8)
//                                      .repeatForever(autoreverses: true),
//                                  value: isPulsating
//                              )
//                      }
//                      .padding(.horizontal, 24)
//                      .onAppear {
//                          isPulsating = true
//                      }
//
//
//                }
////                .padding(.vertical)
//                .background(
//                    Rectangle()
//                        .fill(Color.black)
//                        .edgesIgnoringSafeArea(.bottom)
//                )
//
//            }
//        }
//          .background(Color.black)
//          .foregroundColor(.white)
//          .onAppear {
//              // Animate opacity from 0 to 1 after 2 seconds
//              DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                  withAnimation(.easeIn(duration: 0.5)) {
//                      limitedPlanOpacity = 1.0
//                  }
//              }
//          }
//      }
//
//    
//    private func formatPrice(_ price: Decimal) -> String {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .currency
//        formatter.locale = Locale.current
//        return formatter.string(from: price as NSDecimalNumber) ?? ""
//    }
//}
//
//struct PlanButton: View {
//    let title: String
//    let price: String
//    var subtitle: String? = nil
//    let isSelected: Bool
//    let action: () -> Void
//    
//    var body: some View {
//        Button(action: action) {
//            VStack(alignment: .leading, spacing: 8) {
//                HStack {
//                    VStack(alignment: .leading) {
//                        Text(title)
//                            .font(.system(size: 16/*, weight: isSelected ? .semibold : .regular)*/))
//                            .foregroundStyle(isSelected ? Color.white.opacity(1) : Color.white)
//                    }
//                    Spacer()
//                    Text(price)
//                        .font(.system(size: 16, weight: .semibold))
//                        .foregroundStyle(isSelected ? Color.white : Color.white)
//                    Circle()
//                        .stroke(isSelected ? Color.white : Color.gray, lineWidth: 2)
//                        .frame(width: 24, height: 24)
//                        .overlay(
//                            Circle()
//                                .fill(isSelected ? Color.white : Color.clear)
//                                .frame(width: 12, height: 12)
//                        )
//                }
//                
//                if let subtitle = subtitle, isSelected {
//                    Text(subtitle)
//                        .font(.system(size: 11))
//                        .foregroundColor(isSelected ? Color.gray : Color.clear)
//                        .padding(.top, -4)
//                }
//            }
//            .padding()
//            .frame(maxWidth: .infinity)
//            .contentShape(Rectangle()) // This makes the entire area tappable
//            .background(isSelected ? Color.white.opacity(0.1) : Color.clear)
//            .cornerRadius(12)
////            .overlay(
////                RoundedRectangle(cornerRadius: 24)
////                    .stroke(.gray.opacity(0.3), lineWidth: 2)
////            )
//        }
//        .buttonStyle(PlainButtonStyle())
//        .foregroundStyle(isSelected ? Color.black : Color.white)
//
//    }
//}
//
//// Add this structure to map features to their icons
// struct Feature: Identifiable {
//     let id = UUID()
//     let text: String
//     let icon: String
//     
//     static let all: [Feature] = [
//         Feature(text: "Access 1000+ wisdom on the world's biggest library on success from the world's most successful people", icon: "books.vertical.fill"),
//         Feature(text: "Search through 1000s of quotes, authors and topics", icon: "magnifyingglass"),
//         Feature(text: "Context - get meaning behind quotes", icon: "lightbulb.fill"),
//         Feature(text: "Quotes you won't find anywhere else", icon: "star.fill"),
//         Feature(text: "Lock screen widgets", icon: "iphone"),
//         Feature(text: "No Ads Forever", icon: "hand.raised.slash.fill"),
//         Feature(text: "Categories", icon: "folder.fill"),
//         Feature(text: "Add your own quotes", icon: "plus.square.fill"),
//         Feature(text: "Future Pro features", icon: "sparkles")
//     ]
// }
// 
//
//#Preview {
//    Payment()
//}
