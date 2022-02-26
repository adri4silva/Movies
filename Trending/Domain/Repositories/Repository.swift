import Combine
import Core

enum TrendingError: Error {
    case error
}

protocol RepositoryProtocol {
    func getTrendingMovies(media: String, time: String) -> AnyPublisher<[TrendingResponse.Trending], TrendingError>
}

final class Repository: RepositoryProtocol {
    private let client: TMDBClient

    init(client: TMDBClient) {
        self.client = client
    }

    func getTrendingMovies(media: String, time: String) -> AnyPublisher<[TrendingResponse.Trending], TrendingError> {
        client.load(TrendingResponse.self, from: .trending(media: media, time: time))
            .map(\.results)
            .mapError { _ in TrendingError.error }
            .eraseToAnyPublisher()
    }
}

final class MockRepository: RepositoryProtocol {
    func getTrendingMovies(media: String, time: String) -> AnyPublisher<[TrendingResponse.Trending], TrendingError> {
        Just(
            [
                .movie
            ]
        )
        .setFailureType(to: TrendingError.self)
        .eraseToAnyPublisher()
    }
}
