import Foundation

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    
    // MARK: - Properties
    weak var view: ProfileViewControllerProtocol?
    
    private let profileService: ProfileService
    private let profileImageService: ProfileImageService
    private let logoutService: ProfileLogoutService
    private var profileImageServiceObserver: NSObjectProtocol?
    
    // MARK: - Initialization
    init(
        profileService: ProfileService = .shared,
        profileImageService: ProfileImageService = .shared,
        logoutService: ProfileLogoutService = .shared
    ) {
        self.profileService = profileService
        self.profileImageService = profileImageService
        self.logoutService = logoutService
    }
    
    // MARK: - ProfileViewPresenterProtocol
    func viewDidLoad() {
        setupProfile()
        setupAvatarObserver()
        updateAvatar()
    }
    
    func didTapLogoutButton() {
        view?.showLogoutConfirmation()
    }
    
    func logout() {
        logoutService.logout()
    }
    
    // MARK: - Private Methods
    private func setupProfile() {
        if let profile = profileService.profile {
            updateProfileDetails(profile: profile)
        }
    }
    
    private func setupAvatarObserver() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateAvatar()
        }
    }
    
    private func updateProfileDetails(profile: Profile) {
        view?.updateProfileDetails(profile: profile)
    }
    
    private func updateAvatar() {
        guard let avatarURLString = profileImageService.avatarURL,
              let avatarURL = URL(string: avatarURLString) else {
            view?.updateAvatar(with: nil)
            return
        }
        view?.updateAvatar(with: avatarURL)
    }
    
    deinit {
        if let observer = profileImageServiceObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}
