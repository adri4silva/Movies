import Core
import SwiftUI

protocol DetailFactoryProtocol {
    func detail(using movie: Binding<Movie?>) -> Detail
}

struct DetailFactory: DetailFactoryProtocol {
    private let movieRepository: MovieRepositoryProtocol

    init(movieRepository: MovieRepositoryProtocol) {
        self.movieRepository = movieRepository
    }

    func detail(using movie: Binding<Movie?>) -> Detail {
        Detail(movie: movie, viewModel: .init(movie: movie.wrappedValue, repository: movieRepository))
    }
}
