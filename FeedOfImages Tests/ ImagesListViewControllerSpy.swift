//
//   ImagesListViewControllerSpy.swift
//  FeedOfImages Tests
//
//  Created by Evelina Kebich on 23.11.25.
//

import Foundation
import Foundation
@testable import FeedOfImages

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var updateTableViewAnimatedCalled = false
    var showSingleImageViewControllerCalled = false
    var showLikeErrorAlertCalled = false
    var reloadRowsCalled = false
    
    var oldCount: Int?
    var newCount: Int?
    var receivedPhoto: Photo?
    var receivedError: Error?
    var receivedIndexPaths: [IndexPath]?
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        updateTableViewAnimatedCalled = true
        self.oldCount = oldCount
        self.newCount = newCount
    }
    
    func showSingleImageViewController(with photo: Photo) {
        showSingleImageViewControllerCalled = true
        receivedPhoto = photo
    }
    
    func showLikeErrorAlert(error: Error) {
        showLikeErrorAlertCalled = true
        receivedError = error
    }
    
    func reloadRows(at indexPaths: [IndexPath]) {
        reloadRowsCalled = true
        receivedIndexPaths = indexPaths
    }
}
