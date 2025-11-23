import Foundation

protocol ProfileViewControllerProtocol: AnyObject {
    func updateProfileDetails(profile: Profile)
    func updateAvatar(with url: URL?)
    func showLogoutConfirmation()
}
