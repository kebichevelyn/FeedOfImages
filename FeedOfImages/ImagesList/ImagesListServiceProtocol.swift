//
//  ImagesListServiceProtocol.swift
//  FeedOfImages
//
//  Created by Evelina Kebich on 23.11.25.
//

import Foundation

protocol ImagesListServiceProtocol {
    var photos: [Photo] { get }
    func fetchPhotosNextPage(completion: @escaping (Result<[Photo], Error>) -> Void)
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
}

// Конформность существующего сервиса
extension ImagesListService: ImagesListServiceProtocol {}
