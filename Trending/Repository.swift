import Core
import Foundation
import RxSwift

enum TrendingError: Error {
    case error
}

protocol RepositoryProtocol {
    func getTrendingMovies(media: String, time: String) -> Observable<[TrendingResponse.Trending]>
}

final internal class Repository: RepositoryProtocol {
    private let client: TMDBClient

    init(client: TMDBClient) {
        self.client = client
    }

    func getTrendingMovies(media: String, time: String) -> Observable<[TrendingResponse.Trending]> {
        client.load(TrendingResponse.self, from: .trending(media: media, time: time))
            .map { $0.results }
    }
}
