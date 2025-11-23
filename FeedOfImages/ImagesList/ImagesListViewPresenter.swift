//
//  ImagesListViewPresenter.swift
//  FeedOfImages
//
//  Created by Evelina Kebich on 23.11.25.
//

import Foundation
import UIKit

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    
    // MARK: - Properties
    weak var view: ImagesListViewControllerProtocol?
    
    private let imagesListService: ImagesListServiceProtocol
    private var photos: [Photo] = []
    private var notificationObserver: NSObjectProtocol?
    
    // MARK: - Initialization
    init(imagesListService: ImagesListServiceProtocol = ImagesListService.shared) {
        self.imagesListService = imagesListService
    }
    
    // MARK: - ImagesListViewPresenterProtocol
    func viewDidLoad() {
        setupNotificationObserver()
        fetchPhotosNextPage()
    }
    
    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage { [weak self] result in
            switch result {
            case .success:
                break // Уведомление придет через NotificationCenter
            case .failure(let error):
                print("Ошибка загрузки фото: \(error)")
            }
        }
    }
    
    func changeLike(for photoId: String, isLike: Bool) {
        imagesListService.changeLike(photoId: photoId, isLike: isLike) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    // Обновляем локальные данные
                    self?.photos = self?.imagesListService.photos ?? []
                case .failure(let error):
                    self?.view?.showLikeErrorAlert(error: error)
                }
            }
        }
    }
    
    func photo(at indexPath: IndexPath) -> Photo? {
        guard indexPath.row < photos.count else { return nil }
        return photos[indexPath.row]
    }
    
    var photosCount: Int {
        return photos.count
    }
    
    func calculateCellHeight(for photo: Photo, tableViewWidth: CGFloat) -> CGFloat {
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableViewWidth - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        guard let photo = photo(at: indexPath) else { return }
        view?.showSingleImageViewController(with: photo)
    }
    
    // MARK: - Private Methods
    private func setupNotificationObserver() {
        notificationObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.handlePhotosUpdate()
        }
    }
    
    private func handlePhotosUpdate() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        
        if oldCount != newCount {
            view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
        }
    }
    
    deinit {
        if let observer = notificationObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}
