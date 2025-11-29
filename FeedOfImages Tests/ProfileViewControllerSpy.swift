import Foundation
import UIKit
@testable import FeedOfImages

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var updateProfileDetailsCalled = false
    var updateAvatarCalled = false
    var showLogoutConfirmationCalled = false
    
    var receivedProfile: Profile?
    var receivedAvatarURL: URL?
    
    func updateProfileDetails(profile: Profile) {
        updateProfileDetailsCalled = true
        receivedProfile = profile
    }
    
    func updateAvatar(with url: URL?) {
        updateAvatarCalled = true
        receivedAvatarURL = url
    }
    
    func showLogoutConfirmation() {
        showLogoutConfirmationCalled = true
    }
}
