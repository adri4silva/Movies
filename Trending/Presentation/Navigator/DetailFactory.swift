import Core
import SwiftUI

protocol DetailFactoryProtocol {
    func detail(using movie: Binding<Movie?>, isPushed: Bool) -> Detail
}

struct DetailFactory: DetailFactoryProtocol {
    private let movieRepository: MovieRepositoryProtocol

    init(movieRepository: MovieRepositoryProtocol) {
        self.movieRepository = movieRepository
    }

    func detail(using movie: Binding<Movie?>, isPushed: Bool) -> Detail {
        Detail(
            movie: movie,
            viewModel: .init(movie: movie.wrappedValue, isPushed: isPushed, repository: movieRepository),
            detailFactory: self
        )
    }
}
