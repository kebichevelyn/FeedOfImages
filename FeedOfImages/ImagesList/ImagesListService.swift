import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let fullImageURL: URL
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

enum ImagesListServiceError: Error {
    case requestNotCreated
    case decodingError(Error)
}

extension DateFormatter {
    static let shared = DateFormatter()
}

// Service - Fetcher
final class ImagesListService {
    static let shared = ImagesListService()
    private convenience init() {
        self.init(urlSession: .shared)
    }
    
    private var lastLoadedPage: Int = 1
    private let urlSession: URLSession
    private var task: URLSessionTask?

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
                        createdAt: DateFormatter.shared.date(from: photoResult.createdAt),
                        welcomeDescription: photoResult.description,
                        fullImageURL: photoResult.urls.full,
                        isLiked: photoResult.likedByUser
                    )
                }
                
                DispatchQueue.main.async { [self] in
                    self.lastLoadedPage += 1
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
}
