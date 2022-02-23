import Foundation
import RxSwift

struct TMDBClientConfiguration {
    static let standard = TMDBClientConfiguration(
        apiKey: "f255983bec27fed8a5e4fbd9b0e7092c",
        baseUrl: URL(string: "https://api.themoviedb.org/3")!
    )

    let apiKey: String
    let baseUrl: URL

    var parameters: [String: String] {
        ["api_key": apiKey]
    }
}

public final class TMDBClient {
    private let configuration: TMDBClientConfiguration
    private let session = URLSession(configuration: .default)
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    init(configuration: TMDBClientConfiguration) {
        self.configuration = configuration
    }

    public func load<T: Decodable>(
        _ type: T.Type,
        from endpoint: TMDBApiEndpoint
    ) -> Observable<T> {
        let decoder = self.decoder
        let request = endpoint.request(with: configuration.baseUrl, adding: configuration.parameters)

        return session.rx.send(request: request)
            .map { try decoder.decode(type.self, from: $0) }
    }
}

private extension Reactive where Base: URLSession {
    func send(request: URLRequest) -> Observable<Data> {
        return Observable<Data>.create { observer in
            let task = self.base.dataTask(with: request) { data, response, error in
                if let error = error {
                    observer.onError(error)
                } else {
                    guard let httpResponse = response as? HTTPURLResponse else {
                        fatalError("Unsupported protocol")
                    }

                    if 200 ..< 300 ~= httpResponse.statusCode {
                        if let data = data {
                            observer.onNext(data)
                        }
                        observer.onCompleted()
                    }
                }
            }

            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }
}

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

public final class Assembly {
    public private(set) lazy var client = TMDBClient(configuration: .standard)
    public init() {}
}
