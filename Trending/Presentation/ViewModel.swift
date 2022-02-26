import Combine

final class ViewModel: ObservableObject {
    @Published var trendingMovies: [TrendingResponse.Trending] = []
    @Published var selectedMovie: TrendingResponse.Trending?

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
