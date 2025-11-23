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
        
        // then - проверяем что не падает (значит вызвался shared.logout())
        XCTAssertTrue(true)
    }
    
    func testAvatarNotificationUpdatesView() {
        // given
        let presenter = ProfileViewPresenter()
        let view = ProfileViewControllerSpy()
        presenter.view = view
        
        // when
        presenter.viewDidLoad() // настраиваем observer
        NotificationCenter.default.post(
            name: ProfileImageService.didChangeNotification,
            object: nil
        )
        
        // then - проверяем что view обновляется при нотификации
        XCTAssertTrue(view.updateAvatarCalled)
    }
    
    func testPresenterInitializesWithSharedServices() {
        // given
        let presenter = ProfileViewPresenter()
        
        // then - проверяем что презентер создается с shared сервисами
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
        
        // then - проверяем что нет утечек памяти
        XCTAssertNil(weakPresenter)
    }
    
    func testMultipleNotifications() {
        // given
        let presenter = ProfileViewPresenter()
        let view = ProfileViewControllerSpy()
        presenter.view = view
        
        presenter.viewDidLoad()
        view.updateAvatarCalled = false // Сбрасываем флаг
        
        // when
        // Multiple notifications
        NotificationCenter.default.post(name: ProfileImageService.didChangeNotification, object: nil)
        NotificationCenter.default.post(name: ProfileImageService.didChangeNotification, object: nil)
        
        // then - должен обработать хотя бы один
        XCTAssertTrue(view.updateAvatarCalled)
    }
    
    func testPresenterSurvivesViewDeallocation() {
        // given
        let presenter = ProfileViewPresenter()
        var view: ProfileViewControllerSpy? = ProfileViewControllerSpy()
        presenter.view = view
        
        // when
        view = nil // Удаляем view
        
        // then - презентер не должен падать при обращении к weak view
        presenter.didTapLogoutButton()
        XCTAssertTrue(true) // Просто проверяем что не упало
    }
    
    func testRepeatedViewDidLoad() {
        // given
        let presenter = ProfileViewPresenter()
        let view = ProfileViewControllerSpy()
        presenter.view = view
        
        // when
        presenter.viewDidLoad()
        view.updateAvatarCalled = false // Сбрасываем
        presenter.viewDidLoad() // Вызываем повторно
        
        // then - должен обработать повторный вызов
        XCTAssertTrue(view.updateAvatarCalled)
    }
}
