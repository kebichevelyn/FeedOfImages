import Foundation
import FeedOfImages

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: FeedOfImages.WebViewPresenterProtocol?

    var loadRequestCalled: Bool = false

    func load(request: URLRequest) {
        loadRequestCalled = true
    }

    func setProgressValue(_ newValue: Float) {

    }

    func setProgressHidden(_ isHidden: Bool) {

    }
}
