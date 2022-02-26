import Core
import SwiftUI

protocol DetailFactoryProtocol {
    func detail(using movie: Binding<TrendingResponse.Trending?>) -> Detail
}

struct DetailFactory: DetailFactoryProtocol {
    private let movieRepository: MovieRepositoryProtocol

    init(movieRepository: MovieRepositoryProtocol) {
        self.movieRepository = movieRepository
    }

    func detail(using movie: Binding<TrendingResponse.Trending?>) -> Detail {
        Detail(movie: movie, viewModel: .init(movie: movie.wrappedValue, repository: movieRepository))
    }
}
