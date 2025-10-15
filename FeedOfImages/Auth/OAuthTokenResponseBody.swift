import Foundation

// Декодируем ответ от сервера в формате JSON
struct OAuthTokenResponseBody: Decodable {
    
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
    
    
    private enum ParseError: Error {
        case createdAtFailure
    }
}

