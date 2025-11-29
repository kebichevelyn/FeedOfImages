import Foundation

@testable import FeedOfImages

final class ProfilePresenterSpy: ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol?
    
    var viewDidLoadCalled = false
    var didTapLogoutButtonCalled = false
    var logoutCalled = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didTapLogoutButton() {
        didTapLogoutButtonCalled = true
    }
    
    func logout() {
        logoutCalled = true
    }
}
