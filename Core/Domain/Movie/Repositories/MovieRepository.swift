import Combine

public enum MovieError: Error {
    case error(description: String)
}

public protocol MovieRepositoryProtocol {
    func getCredits(movie: Int) -> AnyPublisher<[CastResponse.Cast], MovieError>
}

public final class MovieRepository: MovieRepositoryProtocol {
    private let client: TMDBClient

    public init(client: TMDBClient) {
        self.client = client
    }

    public func getCredits(movie: Int) -> AnyPublisher<[CastResponse.Cast], MovieError> {
        client.load(CastResponse.self, from: .credits(movie: movie))
            .mapError { error in
                MovieError.error(description: error.localizedDescription)
            }
            .map { response in
                Array(response.cast.prefix(5))
            }
            .eraseToAnyPublisher()
    }
}

public final class MockMovieRepository: MovieRepositoryProtocol {
    public init() {}
    
    public func getCredits(movie: Int) -> AnyPublisher<[CastResponse.Cast], MovieError> {
        Just([])
            .setFailureType(to: MovieError.self)
            .eraseToAnyPublisher()
    }
}
