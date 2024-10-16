import Combine
import SwiftUI

class SearchViewModel: ObservableObject {
    enum Event {
        case dismissAlert
        case searchTapped
        case onAppear
        case onDisappear
    }
    
    @Published var phraseText: String = ""
    @Published var backgroundImage: Data? = nil
    @Published var alert: AlertState?
    @Published var navigateToPicturesList = false

    private var refreshPhotosPublisher = PassthroughSubject<Void, Never>()
    private var backgroundPhotosPublisher: AnyPublisher<Picture, UBError>?
    private var cancellables = Set<AnyCancellable>()
    private var timer: Timer?
    
    func triggerEvent(_ event: Event) {
        switch event {
        case .dismissAlert:
            alert = nil
        case .searchTapped:
            pushPictureList()
        case .onAppear:
            loadBackground()
            break
        case .onDisappear:
            stopBackgroundLoading()
        }
    }

    func pushPictureList() {
        guard !phraseText.isEmpty else {
            alert = .init(title: "Empty Request", message: "Please enter a phrase. We need to know what you are looking for :)")
            return
        }
        
        navigateToPicturesList = true
    }

    func loadBackground() {
        backgroundPhotosPublisher = NetworkManager.shared.fetchRandomPhotos(refreshPublisher: refreshPhotosPublisher.eraseToAnyPublisher())
        
        backgroundPhotosPublisher?.sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let err):
                print(err)
            case .finished:
                print("Background loaded")
            }
        }, receiveValue: { [weak self] picture in
            DispatchQueue.main.async {
                self?.downloadBackgroundImage(from: picture.urls.regular)
            }
        }).store(in: &cancellables)
        
        refreshPhotosPublisher.send()
        timer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { [weak self] _ in
            self?.refreshPhotosPublisher.send()
        }
    }


    func stopBackgroundLoading() {
        timer?.invalidate()
        timer = nil
    }

    private func downloadBackgroundImage(from url: String) {
        Task {
            do {
                let imageData = try await NetworkManager.shared.downloadImageData(from: url)
                DispatchQueue.main.async {
                    withAnimation {
                        self.backgroundImage = imageData
                    }
                }
            } catch {
                print("Failed to download image: \(error)")
            }
        }
    }
}

extension SearchViewModel {
    struct AlertState: Identifiable {
        var title: String
        var message: String
        
        var id: String {
            title
        }
    }
}
