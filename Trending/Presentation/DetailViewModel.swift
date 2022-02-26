import Combine
import Core

final class DetailViewModel: ObservableObject {
    @Published var cast: [CastResponse.Cast] = []
    @Published var similarMovies: [Movie] = []
    @Published var movie: TrendingResponse.Trending?

    var castNames: String {
        cast.map(\.name).joined(separator: ", ")
    }

    private let repository: MovieRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()

    init(movie: TrendingResponse.Trending?, repository: MovieRepositoryProtocol) {
        self.repository = repository
        self.movie = movie
    }

    func onAppear() {
        guard let movie = movie else { return }
        
        repository.getCredits(movie: movie.id)
            .subscribe(on: DispatchQueue.main)
            .replaceError(with: cast)
            .assign(to: \.cast, on: self)
            .store(in: &cancellables)

        repository.getSimilar(movie: movie.id)
            .subscribe(on: DispatchQueue.main)
            .replaceError(with: similarMovies)
            .assign(to: \.similarMovies, on: self)
            .store(in: &cancellables)
    }
}
