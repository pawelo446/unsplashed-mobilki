import Foundation

enum ActionType {
    case add, remove
}

class PersistenceManager {
    static private let favoritesKey = "favorites"
    
    static func updateWith(favorite: Picture, actionType: ActionType, completion: @escaping (Error?) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(var favorites):
                switch actionType {
                case .add:
                    guard !favorites.contains(favorite) else { return }
                    favorites.append(favorite)
                case .remove:
                    favorites.removeAll { $0.id == favorite.id }
                }
                completion(save(favorites: favorites))
                
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    static func isPictureLiked(picture: Picture) -> Bool {
        var favorites: [Picture] = []
        let defaults = UserDefaults.standard
        if let savedFavorites = defaults.object(forKey: favoritesKey) as? Data {
            let decoder = JSONDecoder()
            if let loadedFavorites = try? decoder.decode([Picture].self, from: savedFavorites) {
                favorites = loadedFavorites
            }
        }
        return favorites.contains { $0.id == picture.id }
    }

    static func retrieveFavorites(completion: @escaping (Result<[Picture], Error>) -> Void) {
        let defaults = UserDefaults.standard
        guard let favoritesData = defaults.object(forKey: favoritesKey) as? Data else {
            completion(.success([]))  // Return empty array if no data
            return
        }
        
        let decoder = JSONDecoder()
        do {
            let favorites = try decoder.decode([Picture].self, from: favoritesData)
            completion(.success(favorites))
        } catch {
            completion(.failure(error))
        }
    }
    
    static private func save(favorites: [Picture]) -> Error? {
        let encoder = JSONEncoder()
        do {
            let encodedFavorites = try encoder.encode(favorites)
            let defaults = UserDefaults.standard
            defaults.set(encodedFavorites, forKey: favoritesKey)
            return nil
        } catch {
            return error
        }
    }
}
