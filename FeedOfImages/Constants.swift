import Foundation

enum Constants {
    static let accessKey = "eVDMtRMJDuqPF1swn9g41VAyiEInUFGeBncwECEOm0E"
    static let secretKey = "ci_UDDyeXPnv36BnsiZvU0L_JM2nwyK8xs-d5ZSWeh4"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static private var defaultBaseURLGet: URL {
        guard let url = URL(string: "https://api.unsplash.com") else {
            preconditionFailure("Invalid URL")
        }
        return url
    }
}
