import Foundation
import UIKit

protocol ImagesListViewControllerProtocol: AnyObject {
    func updateTableViewAnimated(oldCount: Int, newCount: Int)
    func showSingleImageViewController(with photo: Photo)
    func showLikeErrorAlert(error: Error)
    func reloadRows(at indexPaths: [IndexPath])
}
