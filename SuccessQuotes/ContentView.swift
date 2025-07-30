//
//  ContentView.swift
//  SuccessQuotes
//
//  Created by Barbara on 17/10/2024.
//

import SwiftUI
import BackgroundTasks

struct ContentView: View {
    @EnvironmentObject private var quoteManager: QuoteManager
    @EnvironmentObject private var notificationManager: NotificationManager
    @State private var currentQuoteIndex = 0
    @State private var offset: CGFloat = 0
    @State private var isDragging = false
    @State private var dragDirection: CGFloat = 0
    @State private var selectedTab = 1
    @State private var focusSearchField = false // New state to control focus in SearchView
    @State private var showSideBar: Bool = false
    @State private var isShowingContext = false
    @State private var quoteContext: String = ""
    @State private var isLoadingContext = false
    private let openAIService = OpenAIService()
    
    // Offset for Both Drag Gesture and showing Menu...
    @State var lastStoredOffset: CGFloat = 0
    @GestureState var gestureOffset: CGFloat = 0
    
    var shouldHideTabBar: Bool {
        selectedTab == 2 && focusSearchField
    }
    
    var body: some View {
        NavigationView {
            
            let sideBarWidth = getRect().width - 30
            
            ZStack {
//                Color.black.ignoresSafeArea(.all)
                //              Color(red: 0.981, green: 0.976, blue: 0.976).ignoresSafeArea(.all) // Add this to ensure the entire card is tappable
                
                HStack {
                    Sidebar()
                    
                    VStack(spacing: 0) {
                        ZStack {
                            // Tab content
                            switch selectedTab {
                            case 0:
                                SavedQuotesView(selectedTab: $selectedTab)
                            case 1:
                                Quotes(showSideBar: $showSideBar, showContext: { quote in
                                    //                                selectedQuote = quote
                                    Task {
                                        isLoadingContext = true
                                        isShowingContext = true
                                        do {
                                            quoteContext = try await openAIService.getQuoteContext(quote: quote)
                                        } catch {
                                            quoteContext = "Failed to load context. Please try again."
                                        }
                                        isLoadingContext = false
                                    }
                                })
                            case 2:
                                
                                SearchView(focusSearchField: $focusSearchField)
                                //                        case 3:
                                //                            // This will trigger the sidebar
                                //                            Color.clear.onAppear {
                                //                                showSideBar = false
                                //                            }
                            default:
                                EmptyView()
                            }
                        }.contentShape(Rectangle())
//                            .clipShape(RoundedCorner(radius: 48, corners: [.bottomLeft, .bottomRight]))
//                            .edgesIgnoringSafeArea(.top) // Allow content to flow
                        
                        if !shouldHideTabBar {
                            Divider()
                            HStack {
                                //                        Spacer()
                                TabButton(/*title: "Saved", */systemImage: selectedTab == 0 ? "suit.heart.fill" : "suit.heart", isSelected: selectedTab == 0)
                                    .onTapGesture {
                                        selectedTab = 0
                                        focusSearchField = false
                                    }
                                Spacer()
                                TabButton(/*title: "Explore",*/ systemImage: "quote.opening", isSelected: selectedTab == 1)
                                    .onTapGesture {
                                        selectedTab = 1
                                        focusSearchField = false
                                    }
                                Spacer()
                                TabButton(/*title: "Search",*/ systemImage: selectedTab == 0 ? "search.fill" : "search", isSelected: selectedTab == 2, useCustomImage: true)
                                    .onTapGesture {
                                        if selectedTab == 2 {
                                            focusSearchField.toggle()
                                        } else {
                                            selectedTab = 2
                                            focusSearchField = false
                                        }
                                    }
                                //                        Spacer()
                                //                        TabButton(title: "Profile", systemImage: "person", isSelected: selectedTab == 3)
                                //                            .onTapGesture {
                                //                                selectedTab = 3
                                //                                focusSearchField = false
                                //                            }
                            }
//                                                .padding(.top)
//                                                .padding(.bottom)
                            .padding(.horizontal, 40)
//                            .background(.black.opacity(0.9))
                        }
                    }
                    .frame(width: getRect().width)
                    // Add overlay when sidebar is shown
                    .overlay {
                        Color.black.opacity(offset > 0 ? min(0.5, offset/sideBarWidth * 0.5) : 0)
                            .ignoresSafeArea()
                    }
                    //          .onAppear {
                    //              quoteManager.checkAndUpdateQuoteOfTheDay()
                    //          }
                    //          .onAppear {
                    //              //check duplicates
                    //              let quoteManager = QuoteManager()
                    //              quoteManager.printDuplicates()
                    //          }
                }
                .frame(width: getRect().width + sideBarWidth)
                .offset(x: -sideBarWidth / 2)
                .offset(x: offset > 0 ? offset : 0)
                .gesture(
                    // Enable drag gesture when sidebar is showing OR on Quotes tab
                    (showSideBar || (selectedTab == 1 && quoteManager.filteredQuotes == nil)) ?
                    DragGesture()
                        .updating($gestureOffset, body: { value, out, _ in
                            out = value.translation.width
                        })
                        .onEnded(onEnd(value:))
                    : nil
                )
            }
            .overlay {
                if isShowingContext {
                    GeometryReader { geometry in
                        Color.black.opacity(0.9)
                            .ignoresSafeArea()
                            .onTapGesture {
                                isShowingContext = false
                            }
                        
                        ContextView(
                            context: quoteContext,
                            isLoading: isLoadingContext,
                            onDismiss: { isShowingContext = false }
                        )
                        .frame(width: UIScreen.main.bounds.width - 40)
                        .background(GradientBackgroundView())
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding()
                        .transition(.scale)
                        .animation(.spring(), value: isShowingContext)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    }
                    .ignoresSafeArea()
                }
            }
            .animation(.easeOut, value: offset == 0)
            .onChange(of: showSideBar) { newValue in
                if showSideBar && offset == 0 {
                    offset = sideBarWidth
                    lastStoredOffset = offset
                }
                
                if !showSideBar && offset == sideBarWidth {
                    offset = 0
                    lastStoredOffset = 0
                }
            }
            .onChange(of: gestureOffset) { newValue in
                onChange()
            }
            .onReceive(NotificationCenter.default.publisher(for: .navigateToQuoteOfTheDay)) { _ in
                // Navigate to quotes tab and scroll to quote of the day
                selectedTab = 1
                quoteManager.scrollToQuoteOfTheDay()
            }
            .onOpenURL { url in
                // Handle deep link to quote of the day
                if url.host == "quoteOfTheDay" {
                    selectedTab = 1
                    quoteManager.scrollToQuoteOfTheDay()
                }
            }
        }
        .accentColor(Color.black) // Sets a universal accent color for the navigation
        .onAppear {
            // Debug: Test quote of the day selection
            quoteManager.debugCurrentDate()
            
            // Force regenerate quote of the day to ensure correct quote
            quoteManager.forceRegenerateQuoteOfTheDay()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            // Check for quote of the day updates when app becomes active
            print("📱 App became active, checking for quote of the day updates...")
            quoteManager.checkAndUpdateQuoteOfTheDay()
            
            // Schedule background refresh
            scheduleBackgroundQuoteRefresh()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            // Alternative way to detect when app comes to foreground
            print("📱 App will enter foreground, checking for quote of the day updates...")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                quoteManager.checkAndUpdateQuoteOfTheDay()
            }
        }
    }
    
    private func scheduleBackgroundQuoteRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.barbara.SuccessQuotes.quoterefresh")
        request.earliestBeginDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("✅ Background quote refresh scheduled from ContentView")
        } catch {
            print("❌ Failed to schedule background quote refresh: \(error)")
        }
    }
    
    func onChange() {
        let sideBarWidth = getRect().width - 30
        
        let newOffset = gestureOffset + lastStoredOffset
        offset = min(max(newOffset, 0), sideBarWidth)  // Allow full range of motion
    }
    
    func onEnd(value: DragGesture.Value) {
        let sideBarWidth = getRect().width - 30
        let translation = value.translation.width
        
        withAnimation(.easeOut(duration: 0.3)) {
            // For closing gesture (negative translation)
            if translation < 0 && -translation > (sideBarWidth / 3) {
                offset = 0
                showSideBar = false
            }
            // For opening gesture (positive translation)
            else if translation > 0 && translation > (sideBarWidth / 3) {
                offset = sideBarWidth
                showSideBar = true
            }
            // If gesture isn't strong enough, return to previous state
            else {
                offset = showSideBar ? sideBarWidth : 0
            }
            
            lastStoredOffset = offset
        }
    }
        
}

struct TabButton: View {
//    let title: String
    let systemImage: String
    let isSelected: Bool
    var useCustomImage: Bool = false

    var body: some View {
        VStack(spacing: 4) {
            if useCustomImage {
                Image(isSelected ? "search.fill" : "search") // Replace with your image name
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24) // Adjust size as needed
            } else {
                Image(systemName: systemImage)
                    .font(.title)
                //            Text(title)
                //                .font(.caption)
            }
        }
        .padding(12)
        .foregroundColor(isSelected ? Color.black : Color.gray)
    }
}

// MARK: - RoundedCorner Shape
struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    ContentView()
        .environmentObject(QuoteManager())
}
