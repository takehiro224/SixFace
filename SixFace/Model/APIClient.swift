import Foundation

enum APIError: Error, CustomStringConvertible {
    case invalidURL
    case invalidResponse
    
    var description: String {
        switch self {
        case .invalidURL:
            return "URLが不正です。"
        case .invalidResponse:
            return "レスポンスデータが不正です。"
        }
    }
}

protocol APIClientProtocol {
    func getImage(url: String, success: @escaping (Data) -> (), failure: @escaping (Error) -> Void)
}

final class APIClient: APIClientProtocol {
    func getImage(url: String, success: @escaping (Data) -> (), failure: @escaping (Error) -> Void) {
        guard let url = URL(string: url) else {
            failure(APIError.invalidURL)
            return
        }
        do {
            let data = try Data(contentsOf: url)
            DispatchQueue.main.async {
                success(data)
            }
        } catch {
            failure(APIError.invalidResponse)
        }
    }
    
}
