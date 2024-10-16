import Foundation

struct PhotoSearchApiResponse: Codable {
    var total: Int = 0
    var totalPages: Int = 0
    var results: [Picture] = []
}

class Picture: Codable, Hashable, Identifiable {
    
    let id: String
    var liked: Bool? = false
    let urls: Urls
    let description: String?
    let createdAt: String?
    let user: User
    let likes: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Urls: Codable {
    let full: String
    let small: String
    let regular: String
}

struct User: Codable {
    let links: Links
    let profileImage: ProfileImage?
    let username: String
    let name: String?
    let instagramUsername: String? //2
    let twitterUsername: String? //2
    let portfolioUrl: String? //2
}

struct ProfileImage: Codable {
    let medium: String
}

struct Links: Codable {
    let html: String
}

extension Picture: Equatable{
    static func == (lhs: Picture, rhs: Picture) -> Bool {
        lhs === rhs
    }
}
