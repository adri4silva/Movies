import Combine
import Core
import Foundation

final class DetailViewModel: ObservableObject {
    enum ExploreSection {
        case similar
        case videos
    }

    @Published var cast: [CastResponse.Cast] = []
    @Published var similarMovies: [Movie] = []
    @Published var videos: [VideoResponse.Video] = []
    @Published var movie: Movie?
    @Published var selectedSection: ExploreSection = .similar

    let isPushed: Bool

    var castNames: String {
        cast.map(\.name).joined(separator: ", ")
    }

    private let repository: MovieRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()

    init(
        movie: Movie?,
        isPushed: Bool,
        repository: MovieRepositoryProtocol
    ) {
        self.repository = repository
        self.isPushed = isPushed
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

        repository.getVideos(movie: movie.id)
            .subscribe(on: DispatchQueue.main)
            .replaceError(with: videos)
            .assign(to: \.videos, on: self)
            .store(in: &cancellables)
    }
}
