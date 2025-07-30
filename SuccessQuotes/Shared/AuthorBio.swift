import SwiftUI
import UIKit
import SafariServices

struct AuthorBio: View {
    let authorName: String
    @State private var authorBio: String = "Loading..."
    @State private var authorImage: UIImage? = nil
    @State private var isLoading = true
    @State private var wikiURL: URL? = nil
    @State private var showSafari = false
    
    var body: some View {
        Button(action: {
            if let url = wikiURL {
                showSafari = true
            }
        }) {
            HStack (alignment: .top) {
                if let image = authorImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                        .overlay(Circle()
                            .stroke(.gray, lineWidth: 1))
                } else {
                    Circle()
                        .foregroundStyle(Color(red: 25/255, green: 25/255, blue: 25/255))
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                        .overlay(Circle()
                            .stroke(.gray, lineWidth: 1))
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(authorName)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                    Text(authorBio)
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
//                        .lineLimit(nil)
//                        .fixedSize(horizontal: false, vertical: true)
//                        .opacity(isLoading ? 0.7 : 1.0)
                }
                Spacer()
                if wikiURL != nil {
                    Image(systemName: "arrow.up.right")
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                }
            }
        }
        .sheet(isPresented: $showSafari) {
            if let url = wikiURL {
                SafariView(url: url)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color(red: 25/255, green: 25/255, blue: 25/255))
        .cornerRadius(24)
        .padding(.horizontal)
        .padding(.top, -20)
        .onChange(of: authorName) { _ in
            fetchWikiBio()
            fetchAuthorImage()
        }
        .onAppear {
            fetchWikiBio()
            fetchAuthorImage()
        }
    }
    
    private func fetchWikiBio() {
        // First check if bio is in cache
        if let cachedBio = CacheManager.shared.getBio(for: authorName) {
            self.authorBio = cachedBio
            if let cachedURL = CacheManager.shared.getURL(for: authorName) {
                self.wikiURL = cachedURL
            }
            isLoading = false
            return
        }
        
        // If not in cache, fetch from network
        isLoading = true
        fetchWikipediaSummaryAndURL(for: authorName) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let response):
                    // Store in cache before setting
                    CacheManager.shared.setBio(response.bio, for: self.authorName)
                    if let url = response.url {
                        CacheManager.shared.setURL(url, for: self.authorName)
                    }
                    self.authorBio = response.bio
                    self.wikiURL = response.url
                case .failure(let error):
                    self.authorBio = "No biography available for \(self.authorName)"
                    print("❌ Bio fetch error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func fetchAuthorImage() {
        // First check if image is in cache
        if let cachedImage = CacheManager.shared.getImage(for: authorName) {
            self.authorImage = cachedImage
            return
        }
        
        // If not in cache, fetch from network
        fetchWikipediaImage(for: authorName) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    // Store in cache before setting
                    CacheManager.shared.setImage(image, for: self.authorName)
                    self.authorImage = image
                case .failure(_):
                    self.authorImage = nil
                }
            }
        }
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let config = SFSafariViewController.Configuration()
        config.barCollapsingEnabled = true
        config.entersReaderIfAvailable = false
        
        let safariVC = SFSafariViewController(url: url, configuration: config)
        safariVC.preferredControlTintColor = .white
        safariVC.dismissButtonStyle = .close
        return safariVC
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

#Preview {
    AuthorBio(authorName: "Steve Jobs")
}
