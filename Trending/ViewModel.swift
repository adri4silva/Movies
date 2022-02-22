import Core
import RxCocoa
import RxSwift

final class ViewModel {
    struct Input {
        let trigger: Driver<Void>
    }
    
    struct Output {
        let movies: Driver<[TrendingResponse.Trending]>
    }

    private let repository: RepositoryProtocol

    init(repository: RepositoryProtocol) {
        self.repository = repository
    }

    func transform(input: Input) -> Output {
        let movies = input.trigger.flatMapLatest {
            return self.repository.getTrendingMovies(media: "all", time: "day")
                .asDriver(onErrorJustReturn: [])
        }

        return Output(
            movies: movies
        )
    }
}
