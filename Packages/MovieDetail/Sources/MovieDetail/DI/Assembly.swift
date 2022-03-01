import Core
import Foundation

public final class Assembly {
    private let coreAssembly: Core.Assembly

    public init(coreAssembly: Core.Assembly) {
        self.coreAssembly = coreAssembly
    }

    public func detailFactory() -> DetailFactoryProtocol {
        DetailFactory(movieRepository: movieRepository())
    }

    func movieRepository() -> MovieRepositoryProtocol {
        MovieRepository(client: coreAssembly.client)
    }
}
