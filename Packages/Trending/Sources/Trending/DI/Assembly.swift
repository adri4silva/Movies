import Core
import MovieDetail
import Foundation

public final class Assembly {
    private let coreAssembly: Core.Assembly
    private let detailAssembly: MovieDetail.Assembly

    public init(
        coreAssembly: Core.Assembly,
        detailAssembly: MovieDetail.Assembly
    ) {
        self.coreAssembly = coreAssembly
        self.detailAssembly = detailAssembly
    }

    public func view() -> Trending.View {
        Trending.View(viewModel: viewModel(), detailFactory: detailAssembly.detailFactory())
    }

    func viewModel() -> ViewModel {
        ViewModel(repository: repository())
    }

    func repository() -> RepositoryProtocol {
        Repository(client: coreAssembly.client)
    }
}
