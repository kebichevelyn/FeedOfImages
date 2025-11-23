import Foundation
@testable import FeedOfImages

final class ImagesListPresenterSpy: ImagesListViewPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol? // Добавляем weak!
    
    var viewDidLoadCalled = false
    var fetchPhotosNextPageCalled = false
    var changeLikeCalled = false
    var photoCalled = false
    var calculateCellHeightCalled = false
    var didSelectRowCalled = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func fetchPhotosNextPage() {
        fetchPhotosNextPageCalled = true
    }
    
    func changeLike(for photoId: String, isLike: Bool) {
        changeLikeCalled = true
    }
    
    func photo(at indexPath: IndexPath) -> Photo? {
        photoCalled = true
        return nil
    }
    
    var photosCount: Int = 0
    
    func calculateCellHeight(for photo: Photo, tableViewWidth: CGFloat) -> CGFloat {
        calculateCellHeightCalled = true
        return 200
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        didSelectRowCalled = true
    }
}
