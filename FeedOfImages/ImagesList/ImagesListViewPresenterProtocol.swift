import Foundation

protocol ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
    func fetchPhotosNextPage()
    func changeLike(for photoId: String, isLike: Bool)
    func photo(at indexPath: IndexPath) -> Photo?
    var photosCount: Int { get }
    func calculateCellHeight(for photo: Photo, tableViewWidth: CGFloat) -> CGFloat
    func didSelectRow(at indexPath: IndexPath)
}
