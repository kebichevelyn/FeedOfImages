//import Foundation
//
//enum WebViewConstants {
//    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
//}
//
//public protocol WebViewPresenterProtocol {
//    var view: WebViewViewControllerProtocol? { get set }
//    func viewDidLoad()
//    func didUpdateProgressValue(_ newValue: Double)
//    func code(from url: URL) -> String?
//}
//
//final class WebViewPresenter: WebViewPresenterProtocol {
//    weak var view: WebViewViewControllerProtocol?
//
//    func viewDidLoad() {
//        guard
//            var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString)
//        else {
//            assertionFailure("Invalid authorization URL string: \(WebViewConstants.unsplashAuthorizeURLString)")
//            return
//        }
//        
//        urlComponents.queryItems = [
//            URLQueryItem(name: "client_id", value: Constants.accessKey),
//            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
//            URLQueryItem(name: "response_type", value: "code"),
//            URLQueryItem(name: "scope", value: Constants.accessScope)
//        ]
//        guard
//            let url = urlComponents.url
//        else {
//            assertionFailure("Failed to construct authorization URLRequest with components: \(urlComponents)")
//            return
//        }
//        
//        let request = URLRequest(url: url)
//
//        didUpdateProgressValue(0)
//
//        view?.load(request: request)
//    }
//
//    func didUpdateProgressValue(_ newValue: Double) {
//        let newProgressValue = Float(newValue)
//        view?.setProgressValue(newProgressValue)
//
//        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
//        view?.setProgressHidden(shouldHideProgress)
//    }
//
//    func shouldHideProgress(for value: Float) -> Bool {
//        abs(value - 1.0) <= 0.0001
//    }
//
//    func code(from url: URL) -> String? {
//        if let urlComponents = URLComponents(string: url.absoluteString),
//           urlComponents.path == "/oauth/authorize/native",
//           let items = urlComponents.queryItems,
//           let codeItem = items.first(where: { $0.name == "code" })
//        {
//            return codeItem.value
//        } else {
//            return nil
//        }
//    }
//}

import Foundation

public protocol WebViewPresenterProtocol {
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
    var view: WebViewViewControllerProtocol? { get set }
}

final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
    var authHelper: AuthHelperProtocol

    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }

    func viewDidLoad() {
        guard let request = authHelper.authRequest() else {
            assertionFailure("Failed to construct authorization URLRequest")
            return
        }
        
        view?.load(request: request)
        didUpdateProgressValue(0)
    }

    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)

        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }

    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }

    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
}
