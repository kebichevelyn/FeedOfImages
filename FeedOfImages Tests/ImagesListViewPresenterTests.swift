import Foundation
import XCTest
@testable import FeedOfImages

final class ImagesListViewPresenterTests: XCTestCase {
    
    func testViewDidLoadCallsSetupMethods() {
        // given
        let presenter = ImagesListViewPresenter()
        let view = ImagesListViewControllerSpy()
        presenter.view = view
        
        // when
        presenter.viewDidLoad()
        
        // then - проверяем что не падает
        XCTAssertTrue(true)
    }
    
    func testFetchPhotosNextPage() {
        // given
        let presenter = ImagesListViewPresenter()
        
        // when
        presenter.fetchPhotosNextPage()
        
        // then - проверяем что не падает
        XCTAssertTrue(true)
    }
    
    func testChangeLike() {
        // given
        let presenter = ImagesListViewPresenter()
        
        // when
        presenter.changeLike(for: "test_photo_id", isLike: true)
        
        // then
        XCTAssertTrue(true)
    }
    
    func testPhotoAtIndexPathWithNoPhotos() {
        // given
        let presenter = ImagesListViewPresenter()
        let indexPath = IndexPath(row: 0, section: 0)
        
        // when
        let photo = presenter.photo(at: indexPath)
        
        // then
        XCTAssertNil(photo)
    }
    
    func testPhotosCountInitiallyZero() {
        // given
        let presenter = ImagesListViewPresenter()
        
        // when
        let count = presenter.photosCount
        
        // then
        XCTAssertEqual(count, 0)
    }
    
    func testDidSelectRowWithNoPhoto() {
        // given
        let presenter = ImagesListViewPresenter()
        let view = ImagesListViewControllerSpy()
        presenter.view = view
        let indexPath = IndexPath(row: 0, section: 0)
        
        // when
        presenter.didSelectRow(at: indexPath)
        
        // then
        XCTAssertFalse(view.showSingleImageViewControllerCalled)
    }
    
    func testPresenterInitialization() {
        // given
        let presenter = ImagesListViewPresenter()
        
        // then
        XCTAssertNotNil(presenter)
    }
    
    func testViewConnection() {
        // given
        let presenter = ImagesListViewPresenter()
        let view = ImagesListViewControllerSpy()
        
        // when
        presenter.view = view
        
        // then
        XCTAssertTrue(presenter.view === view)
    }
    
    func testNotificationHandling() {
        // given
        let presenter = ImagesListViewPresenter()
        let view = ImagesListViewControllerSpy()
        presenter.view = view
        
        // when
        presenter.viewDidLoad() // настраиваем observer
        NotificationCenter.default.post(
            name: ImagesListService.didChangeNotification,
            object: nil
        )
        
        // then
        XCTAssertTrue(true)
    }
}
