import SwiftUI

struct PicturesListView: View {
    @StateObject var viewModel: PictureViewModel
    @State private var searchTerm: String = ""
    
    var body: some View {
        VStack {
            if viewModel.pictureList.isEmpty {
                ProgressView("Loading pictures...")
            } else {
                pictureGrid
            }
        }
        .navigationTitle(viewModel.phrase)
        .navigationBarTitleDisplayMode(.large)
        .accentColor(.red)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    colorPickerMenu
                } label: {
                    Image(systemName: "paintpalette")
                        .foregroundColor(.red)
                }
            }
        }
        .searchable(text: $searchTerm, prompt: "Search for a username")
        .onChange(of: searchTerm) { newValue in
            withAnimation {
                viewModel.filterPictures(filter: newValue)
            }
        }
    }
    
    // Picture grid to show pictures
    var pictureGrid: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 16)], spacing: 16) {
                ForEach(viewModel.filteredPictureList) { picture in
                    PictureCellView(picture: picture, isLiked: picture.liked ?? false)
                        .transition(.scale)
                        .onAppear {
                            viewModel.loadMorePicturesIfNeeded(currentItem: picture)
                        }
                }
            }
            .padding(.horizontal)
        }
    }
    
    var colorPickerMenu: some View {
        VStack {
            ForEach(ColorPicker.allCases, id: \.self) { color in
                Button(action: {
                    viewModel.applyColorFilter(color: color)
                }) {
                    HStack(spacing: 20) {
                        Text(color.name)
                        Image(systemName: color.systemImageName)
                            .foregroundStyle(color.color, .primary, .secondary)
                    }
                    .padding(.vertical, 4)  // Add some padding for vertical space
                }
            }
            
            Button(action: {
                viewModel.applyColorFilter(color: nil)  // Clear color filter
            }) {
                HStack {
                    Text("None")
                    Spacer()
                    Image(systemName: "circle.slash")
                }
                .padding(.vertical, 4)
            }
        }
    }

}
