import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: URL
    let largeImageURL: URL
   // let fullImageURL: URL
    let isLiked: Bool
}

struct PhotoResult: Decodable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String
    let description: String?
    let likedByUser: Bool
    let urls: UrlsResult
}

struct UrlsResult: Decodable {
    let thumb: URL
    let regular: URL
    let full: URL
}

struct LikeResult: Decodable {
    let photo: PhotoLikeResult
}

struct PhotoLikeResult: Decodable {
    let id: String
    let likedByUser: Bool
}


enum ImagesListServiceError: Error {
    case requestNotCreated
    case decodingError(Error)
}

//extension DateFormatter {
//    static let shared = DateFormatter()
//}

extension ISO8601DateFormatter {
    static let shared: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()
}

// Service - Fetcher
final class ImagesListService {
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private convenience init() {
        self.init(urlSession: .shared)
    }
    
    
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int = 1
    private let urlSession: URLSession
    private var task: URLSessionTask?
    private var likeTask: URLSessionTask?
    
    private init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    
    
    func fetchPhotosNextPage(completion: @escaping (Result<[Photo], Error>) -> Void) {
        if task != nil { return }
        
        guard let request = makeRequest() else {
            completion(.failure(ImagesListServiceError.requestNotCreated))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let photoResults):
                let newPhotos: [Photo] = photoResults.compactMap { photoResult in
                    return Photo(
                        id: photoResult.id,
                        size: CGSize(width: photoResult.width, height: photoResult.height),
                        createdAt: ISO8601DateFormatter.shared.date(from: photoResult.createdAt),
                        //createdAt: DateFormatter.shared.date(from: photoResult.createdAt),
                        welcomeDescription: photoResult.description,
                        thumbImageURL: photoResult.urls.regular,
                        largeImageURL: photoResult.urls.full,
                       // fullImageURL: photoResult.urls.full,
                        isLiked: photoResult.likedByUser
                    )
                }
                
                DispatchQueue.main.async { [self] in
                    self.photos.append(contentsOf: newPhotos)
                    self.lastLoadedPage += 1
                    
                    NotificationCenter.default.post(
                        name: ImagesListService.didChangeNotification,
                        object: self
                    )
                    completion(.success(newPhotos))
                }
                
            case .failure(let error):
                print("[ImagesListService] Error: \(error)")
                completion(.failure(error))
            }
            self.task = nil
        }
        
        self.task = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        if likeTask != nil { return }
        
        guard let request = makeLikeRequest(photoId: photoId, isLike: isLike) else {
            completion(.failure(ImagesListServiceError.requestNotCreated))
            return
        }
        
        likeTask = urlSession.objectTask(for: request) { [weak self] (result: Result<LikeResult, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let likeResult):
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    let photo = self.photos[index]
                    let updatedPhoto = Photo(
                        id: photo.id,
                        size: photo.size,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        thumbImageURL: photo.thumbImageURL,
                        largeImageURL: photo.largeImageURL,
                        isLiked: likeResult.photo.likedByUser
                    )
                    
                    DispatchQueue.main.async {
                        self.photos[index] = updatedPhoto
                        completion(.success(()))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(ImagesListServiceError.requestNotCreated))
                    }
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            self.likeTask = nil
        }
        
        likeTask?.resume()
    }
    
    func reset() {
            photos.removeAll()
            lastLoadedPage = 1
            task?.cancel()
            task = nil
            likeTask?.cancel()
            likeTask = nil
        }
}

private extension ImagesListService {
    func makeRequest() -> URLRequest? {
        guard let token = OAuth2TokenStorage.shared.token else { return nil }
        guard
            let url = URL(string: "\(Constants.defaultBaseURLGet)/photos?page=\(lastLoadedPage)")
        else {
            return nil
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func makeLikeRequest(photoId: String, isLike: Bool) -> URLRequest? {
        guard let token = OAuth2TokenStorage.shared.token else { return nil }
        
        let method = isLike ? "POST" : "DELETE"
        guard let url = URL(string: "\(Constants.defaultBaseURLGet)/photos/\(photoId)/like") else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}

