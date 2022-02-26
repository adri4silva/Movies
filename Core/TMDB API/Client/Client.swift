import Foundation
import Combine

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
    ) -> AnyPublisher<T, Error> {
        let decoder = self.decoder
        let request = endpoint.request(with: configuration.baseUrl, adding: configuration.parameters)

        return session.send(request: request)
            .decode(type: type.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}

private extension URLSession {
    func send(request: URLRequest) -> AnyPublisher<Data, Error> {
        return Future { promise in
            let task = self.dataTask(with: request) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    guard let httpResponse = response as? HTTPURLResponse else {
                        fatalError("Unsupported protocol")
                    }

                    if 200 ..< 300 ~= httpResponse.statusCode {
                        if let data = data {
                            promise(.success(data))
                        }
                    }
                }
            }

            task.resume()
        }
        .eraseToAnyPublisher()
    }
}
