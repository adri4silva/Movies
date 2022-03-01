import Combine
import Core
import Foundation

final class ViewModel: ObservableObject {
    @Published var trendingMovies: [Movie] = []
    @Published var selectedMovie: Movie?

    private let repository: RepositoryProtocol
    private var cancellables = Set<AnyCancellable>()

    init(repository: RepositoryProtocol) {
        self.repository = repository
    }

    func onAppear() {
        repository.getTrendingMovies(media: "all", time: "day")
            .receive(on: DispatchQueue.main)
            .mapError { error -> TrendingError in
                print(error)
                return TrendingError.error
            }
            .replaceError(with: trendingMovies)
            .assign(to: \.trendingMovies, on: self)
            .store(in: &cancellables)
    }
}
