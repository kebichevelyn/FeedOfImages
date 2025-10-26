import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let fullImageURL: String
    let isLiked: Bool
}

struct PhotoResult: Decodable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String
    let description: String?
    let likedByUser: Bool?
    let urls: UrlsResult
}

struct UrlsResult: Decodable {
    let thumb: String?
    let regular: String?
    let full: String?
}

final class ImagesListService {
    private(set) var photos: [Photo] = []
    
    private var lastLoadedPage: Int?
    
    // ...
    
    func fetchPhotosNextPage() {
        // ...
    }
}

 

