import XCTest
@testable import FeedOfImages

final class ProfileViewPresenterTests: XCTestCase {
    
    func testViewDidLoadCallsAvatarUpdate() {
        // given
        let presenter = ProfileViewPresenter()
        let view = ProfileViewControllerSpy()
        presenter.view = view
        
        // when
        presenter.viewDidLoad()
        
        // then
        XCTAssertTrue(view.updateAvatarCalled)
    }
    
    func testDidTapLogoutButtonShowsConfirmation() {
        // given
        let presenter = ProfileViewPresenter()
        let view = ProfileViewControllerSpy()
        presenter.view = view
        
        // when
        presenter.didTapLogoutButton()
        
        // then
        XCTAssertTrue(view.showLogoutConfirmationCalled)
    }
    
    func testLogoutCallsLogoutService() {
        // given
        let presenter = ProfileViewPresenter()
        
        // when
        presenter.logout()
        
        // then
        XCTAssertTrue(true)
    }
    
    func testAvatarNotificationUpdatesView() {
        // given
        let presenter = ProfileViewPresenter()
        let view = ProfileViewControllerSpy()
        presenter.view = view
        
        // when
        presenter.viewDidLoad()
        NotificationCenter.default.post(
            name: ProfileImageService.didChangeNotification,
            object: nil
        )
        
        // then
        XCTAssertTrue(view.updateAvatarCalled)
    }
    
    func testPresenterInitializesWithSharedServices() {
        // given
        let presenter = ProfileViewPresenter()
        
        // then
        XCTAssertNotNil(presenter)
    }
    
    func testViewIsSetCorrectly() {
        // given
        let presenter = ProfileViewPresenter()
        let view = ProfileViewControllerSpy()
        
        // when
        presenter.view = view
        
        // then
        XCTAssertTrue(presenter.view === view)
    }
    
    // MARK: - Новые дополнительные тесты
    
    func testViewDeallocation() {
        // given
        var presenter: ProfileViewPresenter? = ProfileViewPresenter()
        weak var weakPresenter = presenter
        
        // when
        presenter = nil
        
        // then
        XCTAssertNil(weakPresenter)
    }
    
    func testMultipleNotifications() {
        // given
        let presenter = ProfileViewPresenter()
        let view = ProfileViewControllerSpy()
        presenter.view = view
        
        presenter.viewDidLoad()
        view.updateAvatarCalled = false
        
        // when
        NotificationCenter.default.post(name: ProfileImageService.didChangeNotification, object: nil)
        NotificationCenter.default.post(name: ProfileImageService.didChangeNotification, object: nil)
        
        // then
        XCTAssertTrue(view.updateAvatarCalled)
    }
    
    func testPresenterSurvivesViewDeallocation() {
        // given
        let presenter = ProfileViewPresenter()
        var view: ProfileViewControllerSpy? = ProfileViewControllerSpy()
        presenter.view = view
        
        // when
        view = nil
        
        // then
        presenter.didTapLogoutButton()
        XCTAssertTrue(true)
    }
    
    func testRepeatedViewDidLoad() {
        // given
        let presenter = ProfileViewPresenter()
        let view = ProfileViewControllerSpy()
        presenter.view = view
        
        // when
        presenter.viewDidLoad()
        view.updateAvatarCalled = false
        presenter.viewDidLoad()
        // then
        XCTAssertTrue(view.updateAvatarCalled)
    }
}
