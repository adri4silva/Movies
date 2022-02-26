import Foundation

enum RequestType: String {
    case get
}

public enum TMDBApiEndpoint {
    case trending(media: String, time: String)
}

extension TMDBApiEndpoint {
    func request(with baseURL: URL, adding parameters: [String: String]) -> URLRequest {
        let url = baseURL.appendingPathComponent(path)

        var newParameters = self.parameters
        parameters.forEach { newParameters.updateValue($1, forKey: $0) }

        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = newParameters.map(URLQueryItem.init)

        var request = URLRequest(url: components.url!)
        request.httpMethod = method.rawValue

        return request
    }
}

private extension TMDBApiEndpoint {
    var method: RequestType {
        switch self {
        case .trending:
            return .get
        }
    }

    var path: String {
        switch self {
        case let .trending(media, time):
            return "/trending/\(media)/\(time)"
        }
    }

    var parameters: [String: String] {
        switch self {
        case .trending:
            return [:]
        }
    }
}
