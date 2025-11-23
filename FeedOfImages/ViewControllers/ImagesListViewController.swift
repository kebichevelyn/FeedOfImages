//import UIKit
//import WebKit
//import Kingfisher
//
//final class ImagesListViewController: UIViewController {
//    private let showSingleImageSegueIdentifier = "ShowSingleImage"
//    
//    @IBOutlet private var tableView: UITableView!
//    
//    private var photos: [Photo] = []
//    
//    private lazy var dateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .long
//        formatter.timeStyle = .none
//        return formatter
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        tableView.rowHeight = 200
//        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
//        
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(updateTableViewAnimated),
//            name: ImagesListService.didChangeNotification,
//            object: nil
//        )
//        
//        
//        loadNextPage()
//    }
//    
//    @objc private func updateTableViewAnimated() {
//        let oldCount = photos.count
//        let newCount = ImagesListService.shared.photos.count
//        
//        photos = ImagesListService.shared.photos
//        
//        if oldCount != newCount {
//            tableView.performBatchUpdates {
//                let indexPaths = (oldCount..<newCount).map {
//                    IndexPath(row: $0, section: 0)
//                }
//                tableView.insertRows(at: indexPaths, with: .automatic)
//            } completion: { _ in }
//        }
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == showSingleImageSegueIdentifier {
//            guard
//                let viewController = segue.destination as? SingleImageViewController,
//                let indexPath = sender as? IndexPath
//            else {
//                assertionFailure("Invalid segue destination")
//                return
//            }
//            let photo = photos[indexPath.row]
//            viewController.fullImageURL = photo.largeImageURL
//            
//        } else {
//            super.prepare(for: segue, sender: sender)
//        }
//    }
//}
//
//extension ImagesListViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return photos.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
//        
//        guard let imageListCell = cell as? ImagesListCell else {
//            return UITableViewCell()
//        }
//        
//        imageListCell.delegate = self
//        
//        imageListCell.selectionStyle = .none
//        
//        configCell(for: imageListCell, with: indexPath)
//        
//        return imageListCell
//    }
//}
//
//
//extension ImagesListViewController {
//    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
//        guard indexPath.row < photos.count else { return }
//        
//        let photo = photos[indexPath.row]
//        
//        
//        cell.cellImage.kf.indicatorType = .activity
//        cell.cellImage.kf.setImage(
//            with: photo.thumbImageURL,
//            placeholder: UIImage(named: "stub_image")
//        ) { [weak self] _ in
//            
//            guard let self = self else { return }
//            self.tableView.reloadRows(at: [indexPath], with: .automatic)
//        }
//        
//        if let createdAt = photo.createdAt {
//            cell.dateLabel.text = dateFormatter.string(from: createdAt)
//        } else {
//            cell.dateLabel.text = ""
//        }
//        
//        cell.setIsLiked(photo.isLiked)
//    }
//}
//
//extension ImagesListViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let photo = photos[indexPath.row]
//        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
//        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
//        let imageWidth = photo.size.width
//        let scale = imageViewWidth / imageWidth
//        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
//        return cellHeight
//    }
//    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        
//        if indexPath.row + 1 == photos.count {
//            ImagesListService.shared.fetchPhotosNextPage { _ in }
//        }
//    }
//}
//
//
//private extension ImagesListViewController {
//    func loadNextPage() {
//        ImagesListService.shared.fetchPhotosNextPage { [weak self] result in
//            guard self != nil else { return }
//            switch result {
//            case .success(_):
//                
//                break
//            case .failure:
//                
//                break
//            }
//        }
//    }
//}
//
//
//extension ImagesListViewController: ImagesListCellDelegate {
//    func imageListCellDidTapLike(_ cell: ImagesListCell) {
//        guard let indexPath = tableView.indexPath(for: cell) else { return }
//        let photo = photos[indexPath.row]
//        
//        UIBlockingProgressHUD.show()
//        
//        ImagesListService.shared.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] (result: Result<Void, Error>) in
//            DispatchQueue.main.async {
//                UIBlockingProgressHUD.dismiss()
//                
//                switch result {
//                case .success:
//                    
//                    self?.photos = ImagesListService.shared.photos
//                    
//                    cell.setIsLiked(self?.photos[indexPath.row].isLiked ?? false)
//                case .failure(let error):
//                    
//                    self?.showLikeErrorAlert(error: error)
//                }
//            }
//        }
//    }
//    
//    private func showLikeErrorAlert(error: Error) {
//        let alert = UIAlertController(
//            title: "Что-то пошло не так(",
//            message: "Не удалось поставить лайк",
//            preferredStyle: .alert
//        )
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        present(alert, animated: true)
//    }
//}

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Properties
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    var presenter: ImagesListViewPresenterProtocol?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        presenter?.viewDidLoad()
    }
    
    // MARK: - Configuration
    private func setupTableView() {
        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let photo = sender as? Photo
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            viewController.fullImageURL = photo.largeImageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Cell Configuration
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let photo = presenter?.photo(at: indexPath) else { return }
        
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(
            with: photo.thumbImageURL,
            placeholder: UIImage(named: "stub_image")
        ) { [weak self] _ in
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        if let createdAt = photo.createdAt {
            cell.dateLabel.text = dateFormatter.string(from: createdAt)
        } else {
            cell.dateLabel.text = ""
        }
        
        cell.setIsLiked(photo.isLiked)
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.photosCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        imageListCell.delegate = self
        imageListCell.selectionStyle = .none
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photo = presenter?.photo(at: indexPath) else { return 200 }
        return presenter?.calculateCellHeight(for: photo, tableViewWidth: tableView.bounds.width) ?? 200
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let photosCount = presenter?.photosCount,
              indexPath.row + 1 == photosCount else { return }
        presenter?.fetchPhotosNextPage()
    }
}

// MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell),
              let photo = presenter?.photo(at: indexPath) else { return }
        
        UIBlockingProgressHUD.show()
        presenter?.changeLike(for: photo.id, isLike: !photo.isLiked)
    }
}

// MARK: - ImagesListViewControllerProtocol
extension ImagesListViewController: ImagesListViewControllerProtocol {
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        tableView.performBatchUpdates {
            let indexPaths = (oldCount..<newCount).map {
                IndexPath(row: $0, section: 0)
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }
    
    func showSingleImageViewController(with photo: Photo) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: photo)
    }
    
    func showLikeErrorAlert(error: Error) {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось поставить лайк",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func reloadRows(at indexPaths: [IndexPath]) {
        tableView.reloadRows(at: indexPaths, with: .automatic)
    }
}
