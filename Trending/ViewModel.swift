import Combine

final class ViewModel: ObservableObject {
    @Published var trendingMovies: [TrendingResponse.Trending] = []

    private let repository: RepositoryProtocol
    private var cancellables = Set<AnyCancellable>()

    init(repository: RepositoryProtocol) {
        self.repository = repository
    }

    func onAppear() {
        repository.getTrendingMovies(media: "all", time: "day")
            .replaceError(with: trendingMovies)
            .assign(to: \.trendingMovies, on: self)
            .store(in: &cancellables)
    }
}
