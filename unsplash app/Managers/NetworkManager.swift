import Foundation
import Combine

class NetworkManager {
    static let shared = NetworkManager()
    private let cache = NSCache<NSString, NSData>()
    private let decoder: JSONDecoder
    private let baseUrl = "https://api.unsplash.com"
    private let apiKey = "bfeknoZmShMsBPmD_6ZNp_0QUtkMcOAX5tP5UiKHDNs"
    
    private init() {
        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    func fetchRequest(for phrase: String, page: Int, color: ColorPicker?) async throws -> PhotoSearchApiResponse {
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: "30"),
            URLQueryItem(name: "query", value: phrase.replacingOccurrences(of: " ", with: "+")),
            URLQueryItem(name: "client_id", value: apiKey)
        ]
        
        if let color = color {
            queryItems.append(URLQueryItem(name: "color", value: color.rawValue))
        }
        
        guard var urlComponents = URLComponents(string: baseUrl + "/search/photos") else {
            throw UBError.invalidRequest
        }
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            throw UBError.invalidRequest
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw UBError.invalidResponse
        }
        
        return try decoder.decode(PhotoSearchApiResponse.self, from: data)
    }
    
    func fetchRandomPhotos(refreshPublisher: AnyPublisher<Void, Never>) -> AnyPublisher<Picture, UBError> {
        guard let url = URL(string: "\(baseUrl)/photos/random?client_id=\(apiKey)") else {
            return Fail(error: UBError.invalidRequest).eraseToAnyPublisher()
        }
        
        return refreshPublisher
            .flatMap { _ in
                URLSession.shared.dataTaskPublisher(for: url)
                    .map(\.data)
                    .decode(type: Picture.self, decoder: self.decoder)
                    .mapError { error in
                        if error is URLError {
                            return UBError.invalidRequest
                        } else if error is DecodingError {
                            return UBError.invalidData
                        } else {
                            return UBError.unableToComplete
                        }
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    func downloadImageData(from urlString: String) async throws -> Data {
        let cacheKey = NSString(string: urlString)
        
        if let cachedData = cache.object(forKey: cacheKey) {
            return cachedData as Data
        }
        
        guard let url = URL(string: urlString) else {
            throw UBError.invalidRequest
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        cache.setObject(data as NSData, forKey: cacheKey)
        return data
    }
}
