import Combine
import Core

final class DetailViewModel: ObservableObject {
    @Published var cast: [CastResponse.Cast] = []
    @Published var movie: TrendingResponse.Trending?

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
            .map { cast in
                print(cast)
                return cast
            }
            .replaceError(with: cast)
            .assign(to: \.cast, on: self)
            .store(in: &cancellables)
    }
}
