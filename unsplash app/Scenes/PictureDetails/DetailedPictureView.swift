import SwiftUI

struct DetailedPictureView: View {
    @Environment(\.presentationMode) var presentationMode  // To dismiss the modal
    let picture: Picture

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Use AsyncImage to load the picture
                AsyncImage(url: URL(string: picture.urls.regular)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView("Loading image...")
                            .frame(maxWidth: .infinity)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .cornerRadius(10)
                    case .failure:
                        Text("Failed to load image")
                            .frame(maxWidth: .infinity)
                    @unknown default:
                        EmptyView()
                    }
                }
                
//                ItemInfoHeader(picture: picture)  // Your custom header view
                
                HStack(spacing: 16) {
                    CustomButton.shareButton {
                        shareImage(picture)
                    }
                    CustomButton.saveButton {
                        saveImage(picture)
                    }
                }
                
//                if let socialMediaButtons = getSocialMediaButtons(for: picture) { //Initializer for conditional binding must have Optional type, not '[SocialMediaButton]'
//                    ForEach(socialMediaButtons, id: \.platform) { button in
//                        button
//                    }
//                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button("Close") {
            presentationMode.wrappedValue.dismiss()
        })
    }

    // Function to handle share action
    func shareImage(_ picture: Picture) {
        // Share logic here (could use ShareLink in SwiftUI or UIKit activity view)
    }

    // Function to handle save action
    func saveImage(_ picture: Picture) {
        // Logic to save image here
    }

    // Function to return social media buttons
    func getSocialMediaButtons(for picture: Picture) -> [SocialMediaButton] {
        var buttons = [SocialMediaButton]()
        
        if let twitterUsername = picture.user.twitterUsername {
            buttons.append(SocialMediaButton(platform: "Twitter", username: twitterUsername, icon: "twitter"))
        }
        if let instagramUsername = picture.user.instagramUsername {
            buttons.append(SocialMediaButton(platform: "Instagram", username: instagramUsername, icon: "camera"))
        }
        return buttons
    }
}

struct SocialMediaButton: View, Hashable {
    let platform: String
    let username: String
    let icon: String
    
    var body: some View {
        Button(action: {
            openSocialMedia(platform: platform, username: username)
        }) {
            HStack {
                Image(systemName: icon)
                Text("\(platform): \(username)")
                    .font(.subheadline)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
        }
    }

    // Logic to open the social media platform
    func openSocialMedia(platform: String, username: String) {
        // Open social media logic (e.g., open a URL)
    }

    // Conformance to Hashable (necessary for ForEach)
    func hash(into hasher: inout Hasher) {
        hasher.combine(platform)
        hasher.combine(username)
    }

    static func ==(lhs: SocialMediaButton, rhs: SocialMediaButton) -> Bool {
        return lhs.platform == rhs.platform && lhs.username == rhs.username
    }
}
