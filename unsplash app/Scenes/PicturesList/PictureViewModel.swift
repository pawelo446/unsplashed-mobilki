import SwiftUI
import Combine

class PictureViewModel: ObservableObject {
    @Published var phrase: String = ""
    @Published var pictureList: [Picture] = []
    @Published var filteredPictureList: [Picture] = []
    @Published var isFiltering = false
    @Published var isLoadingMore = false
    @Published var currentPage = 1
    @Published var totalPages = 1
    @Published var currentColor: ColorPicker? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    init(phrase: String) {
        self.phrase = phrase
        getPictures(color: nil, page: 1, phrase: phrase)
    }
    
    func getPictures(color: ColorPicker?, page: Int, phrase: String) {
        isLoadingMore = true
        
        Task {
            do {
                let response = try await NetworkManager.shared.fetchRequest(for: phrase, page: page, color: color)
                DispatchQueue.main.async {
                    self.totalPages = response.totalPages
                    self.pictureList.append(contentsOf: response.results)
                    self.filteredPictureList = self.pictureList
                    self.isLoadingMore = false
                }
            } catch {
                print("Failed to fetch pictures: \(error)")
                isLoadingMore = false
            }
        }
    }
    
    func loadMorePicturesIfNeeded(currentItem: Picture?) {
        guard !isLoadingMore && currentPage < totalPages else { return }
        
        if let currentItem = currentItem,
           let lastItem = pictureList.last,
           currentItem.id == lastItem.id {
            currentPage += 1
            getPictures(color: currentColor, page: currentPage, phrase: phrase)
        }
    }
    
    func filterPictures(filter: String) {
        if filter.isEmpty {
            isFiltering = false
            filteredPictureList = pictureList
        } else {
            isFiltering = true
            filteredPictureList = pictureList.filter { $0.user.username.lowercased().contains(filter.lowercased()) }
        }
    }
    
    func applyColorFilter(color: ColorPicker?) {
        withAnimation {
            self.currentColor = color
            self.pictureList = []
            self.filteredPictureList = []
            self.getPictures(color: color, page: 1, phrase: self.phrase)  // Re-fetch pictures with the selected color filter
        }
    }
}
