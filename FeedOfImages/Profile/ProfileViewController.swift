import UIKit
import WebKit
import Kingfisher

final class ProfileViewController: UIViewController {
    private var nameLabel: UILabel?
    private var loginName: UILabel?
    private var descriptionLabel: UILabel?
    private var avatarImage: UIImageView!
    private var logoutButton: UIButton?
    private var profileInformation: [UIView] = []
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViewsToScreen()
        
        if let profile = ProfileService.shared.profile {
            updateProfileDetails(profile: profile)
        }
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
    }
    
    // MARK: - private functions
    
    private func updateProfileDetails(profile: Profile) {
        nameLabel?.text = profile.name
        loginName?.text = profile.loginName
        descriptionLabel?.text = profile.bio
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let imageUrl = URL(string: profileImageURL),
            let imageView = avatarImage
        else { return }

        print("imageUrl: \(imageUrl)")

        let placeholderImage = UIImage(systemName: "person.circle.fill")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 70, weight: .regular, scale: .large))

        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: imageUrl,
            placeholder: placeholderImage,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage,
                .forceRefresh
            ]) { result in
                switch result {
                case .success(let value):
                    print(value.image)
                    print(value.cacheType)
                    print(value.source)
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    private func addViewsToScreen() {
        
        let avatarImage = UIImageView(image: UIImage(resource: .avatar))
        let nameLabel = UILabel()
        let loginName = UILabel()
        let descriptionLabel = UILabel()
        let logoutButton = UIButton.systemButton(
            with: UIImage(named: "logout_button")!,
            target: self,
            action: #selector(didTapLogoutButton)
        )
        
        self.nameLabel = nameLabel
        self.loginName = loginName
        self.descriptionLabel = descriptionLabel
        self.avatarImage = avatarImage
        self.logoutButton = logoutButton
        
        profileInformation = [nameLabel, loginName, descriptionLabel, avatarImage]
        
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = .white
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        
        loginName.text = "@ekaterina_nov"
        loginName.textColor = UIColor(named: "grayColor")
        loginName.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        logoutButton.tintColor = UIColor(named: "YP Red")
        
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        loginName.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(avatarImage)
        view.addSubview(nameLabel)
        view.addSubview(loginName)
        view.addSubview(descriptionLabel)
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            avatarImage.widthAnchor.constraint(equalToConstant: 70),
            avatarImage.heightAnchor.constraint(equalToConstant: 70),
            avatarImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            avatarImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            
            nameLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor),
            
            loginName.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginName.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: loginName.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor),
            
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    @objc private func didTapLogoutButton () {
        
        for view in profileInformation {
            view.removeFromSuperview()
        }
        profileInformation.removeAll()
        
        nameLabel = nil
        loginName = nil
        descriptionLabel = nil
        avatarImage = nil
        
        let emptyAvatar = UIImageView(image: UIImage(named: "emptyAvatar"))
        emptyAvatar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyAvatar)
        guard let logoutButton = self.logoutButton else { return }
        
        NSLayoutConstraint.activate([
            emptyAvatar.widthAnchor.constraint(equalToConstant: 70),
            emptyAvatar.heightAnchor.constraint(equalToConstant: 70),
            emptyAvatar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emptyAvatar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            
            logoutButton.centerYAnchor.constraint(equalTo: emptyAvatar.centerYAnchor)
        ])
    }
}
