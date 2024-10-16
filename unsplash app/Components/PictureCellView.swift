import SwiftUI

struct PictureCellView: View {
    let picture: Picture
    @State private var isLiked: Bool
    @State private var isShowingDetail = false
    
    init(picture: Picture, isLiked: Bool = false) {
        self.picture = picture
        _isLiked = State(initialValue: PersistenceManager.isPictureLiked(picture: picture))
    }

    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: picture.urls.small)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width / 2 - 16, height: UIScreen.main.bounds.width / 2 - 16)  // Ensure square shape
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.clear, lineWidth: 1))
                } placeholder: {
                    ProgressView()
                        .frame(width: UIScreen.main.bounds.width / 2 - 16, height: UIScreen.main.bounds.width / 2 - 16)
                }

                // Smaller heart button with padding
                Button(action: {
                    isLiked.toggle()
                    handleLikeToggle()
                }) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(isLiked ? .red : .white)
                        .padding(8)
                        .background(Circle().fill(Color.black.opacity(0.6)))
                }
                .padding([.top, .trailing], 10)
            }

            Text(picture.user.username)
                .font(.system(size: 14, weight: .medium))
                .lineLimit(1)
                .padding([.leading, .bottom, .trailing], 4)
        }
        .onTapGesture {
            isShowingDetail.toggle()
        }
        .sheet(isPresented: $isShowingDetail) {
            DetailedPictureView(picture: picture)
        }
    }

    private func handleLikeToggle() {
        if isLiked {
            PersistenceManager.updateWith(favorite: picture, actionType: .add) { error in
                if let error = error {
                    print(error)
                }
            }
        } else {
            PersistenceManager.updateWith(favorite: picture, actionType: .remove) { error in
                if let error = error {
                    print(error)
                }
            }
        }
    }
}
