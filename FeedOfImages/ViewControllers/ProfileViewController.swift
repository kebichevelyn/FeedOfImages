import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    // MARK: - UI Properties
    private var nameLabel: UILabel?
    private var loginName: UILabel?
    private var descriptionLabel: UILabel?
    private var avatarImage: UIImageView?
    private var logoutButton: UIButton?
    
    // MARK: - Presenter
    var presenter: ProfileViewPresenterProtocol?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter?.viewDidLoad()
    }
    
    // MARK: - Actions
    @objc private func didTapLogoutButton() {
        presenter?.didTapLogoutButton()
    }
}

// MARK: - ProfileViewControllerProtocol
extension ProfileViewController: ProfileViewControllerProtocol {
    func updateProfileDetails(profile: Profile) {
        nameLabel?.text = profile.name
        loginName?.text = profile.loginName
        descriptionLabel?.text = profile.bio
    }
    
    func updateAvatar(with url: URL?) {
        guard let imageView = avatarImage else { return }
        
        let placeholderImage = UIImage(systemName: "person.circle.fill")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 70, weight: .regular, scale: .large))
        
        guard let url = url else {
            imageView.image = placeholderImage
            return
        }
        
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: url,
            placeholder: placeholderImage,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage,
                .forceRefresh
            ]) { result in
                switch result {
                case .success(let value):
                    print("аватарка загружена: \(value.image.size)")
                case .failure(let error):
                    print("ошибка загрузки аватарки: \(error)")
                }
            }
    }
    
    func showLogoutConfirmation() {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            self?.presenter?.logout()
        })
        
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel))
        
        present(alert, animated: true)
    }
}

// MARK: - UI Setup
private extension ProfileViewController {
    func setupView() {
        view.backgroundColor = UIColor(named: "launchscreen + 1 screen")
        addViewsToScreen()
    }
    
    func addViewsToScreen() {
        let avatarImage = UIImageView(image: UIImage(resource: .avatar))
        let nameLabel = UILabel()
        let loginName = UILabel()
        let descriptionLabel = UILabel()
        
        let logoutButtonImage = UIImage(named: "logout_button") ?? UIImage()
        let logoutButton = UIButton.systemButton(
            with: logoutButtonImage,
            target: self,
            action: #selector(didTapLogoutButton)
        )
        
        self.nameLabel = nameLabel
        self.loginName = loginName
        self.descriptionLabel = descriptionLabel
        self.avatarImage = avatarImage
        self.logoutButton = logoutButton
        
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
}
